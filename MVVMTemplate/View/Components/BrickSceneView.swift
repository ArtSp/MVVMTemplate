//
//  BrickSceneView.swift
//  Created by Artjoms Spole on 08/06/2022.
//

import SpriteKit
import SwiftUI
import CoreMotion

// MARK: - BrickSceneView

struct BrickSceneView: View {
    
    @State var contentSize: CGSize = .zero
    
    private let scene: BrickScene = {
        let scene = BrickScene()
        scene.size = .zero
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        return scene
    }()
    
    var body: some View {
        SpriteView(
            scene: scene,
            options: [
                .allowsTransparency,
                .shouldCullNonVisibleNodes,
            ]
        )
            .ignoresSafeArea()
            .readSize { contentSize = $0 }
    }
    
    func dropItems(
        at location: CGPoint
    ) {
        scene.dropItems(at: scene.convertPoint(toView: location))
    }
    
    func updateLabelFrame(
        id: ID,
        rect: CGRect
    ) {
        let viewOrigin = CGPoint(
            x: rect.origin.x + rect.width / 2,
            y: rect.origin.y + rect.height / 2
        )
        let origin = scene.convertPoint(toView: viewOrigin)
        scene.addOrMoveNode(name: "\(id)", rect: .init(origin: origin, size: rect.size))
    }
    
    func removeAllLabelRects() {
        scene.removeAllLabelRects()
    }
}

// MARK: - BrickScene

private class BrickScene: SKScene {
    
    let motionManager = CMMotionManager()
    var lastNodeRemoveTime: Date?
    let boundaryCategoryMask: UInt32 = 1 << 1
    let nodeCategoryMask: UInt32 = 1 << 2
    @Atomic var spriteTexture: SKTexture?
    @Atomic var aspectRatio: CGFloat = 1
    
    override init() {
        super.init()
        
        commonInit()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        commonInit()
    }
    
    required init?(
        coder aDecoder: NSCoder
    ) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] accelerometerData, _ in
            if let acceleration = accelerometerData?.acceleration {
                self?.accelerationUpdated(acceleration)
            }
        }
    }
    
    var randomNode: SKNode {
        let random = CGFloat((10...30).randomElement()!)
        let size = CGSize(width: random, height: random)
        var node: SKShapeNode
        
        switch (0...10).randomElement() {
        case 0:
            var spriteNode: SKSpriteNode
            let spriteWidth = 50
            guard let spriteTexture = spriteTexture else { fallthrough }
            
            spriteNode = SKSpriteNode(texture: spriteTexture)
            spriteNode.size = .init(width: spriteWidth, height: spriteWidth * Int(aspectRatio))
            spriteNode.physicsBody = .init(rectangleOf: spriteNode.size)
            return spriteNode
            
        case 1:
            node = .init(rectOf: size)
            node.physicsBody = .init(rectangleOf: size)

        case 2:
            let w = size.width / 2
            let h = size.height
            let up = Bool.random()
            let trianglePath = UIBezierPath()
            trianglePath.move(to: .zero)
            trianglePath.addLine(to: .init(x: -w, y: up ? h : -h))
            trianglePath.addLine(to: .init(x: w, y: up ? h : -h))
            trianglePath.close()

            node = .init(path: trianglePath.cgPath)
            node.physicsBody = .init(polygonFrom: trianglePath.cgPath)
            
        default:
            node = .init(circleOfRadius: size.width / 2)
            node.physicsBody = .init(circleOfRadius: size.width / 2)
        }
        
        node.fillColor = .random
        node.strokeColor = .random
        node.lineWidth = 0
        return node
    }
    
    func captureScreenshot() -> UIImage {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        let ctx = UIGraphicsGetCurrentContext()!
        layer.render(in: ctx)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.borderWidth = 15
        shapeLayer.path = UIBezierPath(rect: .init(origin: .zero, size: layer.frame.size)).cgPath
        shapeLayer.render(in: ctx)
        
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot ?? UIImage()
    }
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.categoryBitMask = boundaryCategoryMask
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        guard let lastNodeRemoveTime = lastNodeRemoveTime else {
            lastNodeRemoveTime = Date()
            return
        }
        
        if lastNodeRemoveTime.distance(to: .now) > 0.1 {
            removeAnyNode()
            self.lastNodeRemoveTime = Date()
        }
        
    }
    
    func accelerationUpdated(_ acceleration: CMAcceleration) {
        let g = 9.8
        let gravityX = g * acceleration.x
        let gravityY = g * acceleration.y
        physicsWorld.gravity = CGVector(dx: gravityX, dy: gravityY)
    }
    
    func removeAnyNode() {
        if let node = children.shuffled().first(where: { $0.name.isNil }) {
            guard !node.hasActions() else { return }
            let action = SKAction.sequence([
                .scale(by: 2.5, duration: 5),
                SKAction.group([
                    .scale(by: 2, duration: 0.1),
                    .rotate(byAngle: .random(in: (-10...10)), duration: 0.1),
                    .fadeOut(withDuration: 0.1)
                ]),
                .removeFromParent()
            ])
            node.run(action)
        }
    }
    
    func dropItems(count: Int = 30, at location: CGPoint) {
        DispatchQueue(label: "opa").async {
            if self.spriteTexture.isNil {
                var img: UIImage!
                DispatchQueue.main.sync {
                    img = self.captureScreenshot()
                }
                self.spriteTexture = SKTexture(cgImage: img.cgImage!)
                self.aspectRatio = img.size.height / img.size.width
            }
            
            (0..<count).forEach { _ in
                let node = self.randomNode
                node.position = location
                
                DispatchQueue.main.sync {
                    self.addChild(node)
                    node.physicsBody?.applyImpulse(
                        CGVector(
                            dx: CGFloat((-30...30).randomElement()!),
                            dy: CGFloat((-30...30).randomElement()!)
                        )
                    )
                }
            }
        }
        
    }
    
    func removeAllLabelRects() {
        scene?.children
            .filter { !$0.name.isNil }
            .forEach { $0.removeFromParent() }
    }
    
    func addOrMoveNode(name: String, rect: CGRect) {
        var node: SKNode? = scene?.childNode(withName: name)
        let mustAddNode = node.isNil
        defer { if mustAddNode { scene?.addChild(node!) } }
        if mustAddNode {
            node = SKNode()
            node?.name = name
            node?.physicsBody = .init(rectangleOf: rect.size)
            node?.physicsBody?.isDynamic = false
        }
        
        node?.physicsBody?.node?.position = rect.origin
    }
}

// MARK: - Helpers

private extension UIColor {
    class var random: UIColor {
        UIColor(red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1.0)
    }
}
