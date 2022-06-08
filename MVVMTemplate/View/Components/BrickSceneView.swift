//
//  BrickSceneView.swift
//  Created by Artjoms Spole on 08/06/2022.
//

import SpriteKit
import SwiftUI
import CoreMotion

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
        SpriteView(scene: scene, options: [.allowsTransparency])
            .ignoresSafeArea()
            .readSize { contentSize = $0 }
    }
    
    func dropItems(
        at location: CGPoint
    ) {
        scene.dropItems(at: scene.convertPoint(toView: location))
    }
}

private class BrickScene: SKScene {
    
    let motionManager = CMMotionManager()
    
    override init() {
        super.init()
        
        commonInit()
    }
    
    override init(
        size: CGSize
    ) {
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
    
    func accelerationUpdated(
        _ acceleration: CMAcceleration
    ) {
        let boostedX = acceleration.x * 10
        let boostedY = acceleration.y * 10
        physicsWorld.gravity = CGVector(dx: boostedX, dy: boostedY)
    }
    
    override func didMove(
        to view: SKView
    ) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    var randomNode: SKNode {
        let random = CGFloat((10...50).randomElement()!)
        let size = CGSize(width: random, height: random)
        var node: SKShapeNode
        
        switch (0...2).randomElement() {
        case 0:
            node = .init(rectOf: size)
            node.physicsBody = .init(rectangleOf: size)
            
        case 1:
            node = .init(circleOfRadius: size.width / 2)
            node.physicsBody = .init(circleOfRadius: size.width / 2)
            
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
            fatalError()
        }
        
        node.fillColor = .random.withAlphaComponent(CGFloat((70...100).randomElement()!) / 100)
        node.lineWidth = 0
        return node
    }

    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        dropItems(count: 1, at: location)
    }
    
    override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        dropItems(count: 1, at: location)
    }
    
    func dropItems(
        count: Int = 30,
        at location: CGPoint
    ) {
        (0..<count).forEach { _ in
            let node = randomNode
            node.position = location
            addChild(node)
            node.physicsBody?.applyImpulse(
                CGVector(
                    dx: CGFloat((-30...30).randomElement()!),
                    dy: CGFloat((-30...30).randomElement()!)
                )
            )
        }
    }
}

private extension UIColor {
    class var random: UIColor {
        UIColor(red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1.0)
    }
}
