//
//  MetalView.swift
//  Created by Artjoms Spole on 10/06/2022.
//

import SwiftUI
import MetalKit

class MetalView: MTKView {
    var renderer: Renderer!
    
    init() {
        super.init(frame: .zero, device: MTLCreateSystemDefaultDevice())
        // Make sure we are on a device that can run metal!
        guard let defaultDevice = device else {
            fatalError("Device loading error")
        }
        colorPixelFormat = .bgra8Unorm
        // Our clear color, can be set to any color
        clearColor = MTLClearColor(red: 0.1, green: 0.57, blue: 0.25, alpha: 1)
        createRenderer(device: defaultDevice)
    }
    
    required init(
        coder: NSCoder
    ) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createRenderer(
        device: MTLDevice
    ) {
        renderer = Renderer(device: device)
        delegate = renderer
    }
    
}

// MARK: - Renderer

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}

class Renderer: NSObject {
    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!

    var vertexBuffer: MTLBuffer!
    var vertices: [Vertex] = [
        Vertex(position: .init(0, 1, 0), color: .init(1, 0, 0, 1)),
        Vertex(position: .init(-1, -1, 0), color: .init(0, 1, 0, 1)),
        Vertex(position: .init(1, -1, 0), color: .init(0, 0, 1, 1))
    ]

    init(
        device: MTLDevice
    ) {
        super.init()
        createCommandQueue(device: device)
        createPipelineState(device: device)
        createBuffers(device: device)
    }

    // MARK: Builders

    func createCommandQueue(
        device: MTLDevice
    ) {
        commandQueue = device.makeCommandQueue()
    }

    func createPipelineState(
        device: MTLDevice
    ) {
        // The device will make a library for us
        let library = device.makeDefaultLibrary()
        // Our vertex function name
        let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
        // Our fragment function name
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
        // Create basic descriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        // Attach the pixel format that si the same as the MetalView
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        // Attach the shader functions
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        // Try to update the state of the renderPipeline
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print(error.localizedDescription)
        }
    }

    func createBuffers(
        device: MTLDevice
    ) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: MemoryLayout<Vertex>.stride * vertices.count,
                                         options: [])
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(
        _ view: MTKView,
        drawableSizeWillChange size: CGSize
    ) {}

    func draw(
        in view: MTKView
    ) {
        // Get the current drawable and descriptor
        guard let drawable = view.currentDrawable,
            let renderPassDescriptor = view.currentRenderPassDescriptor else {
                return
        }
        // Create a buffer from the commandQueue
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        // Pass in the vertexBuffer into index 0
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        // Draw primitive at vertextStart 0
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)

        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

// MARK: - Preview:

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView {
            MetalView()
        }
    }
}
 
