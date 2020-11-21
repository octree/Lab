import MetalKit
import PlaygroundSupport

// set up View
let frame = NSRect(x: 0, y: 0, width: 300, height: 300)
let view = MTKView(frame: frame, device: device)
view.clearColor = MTLClearColor(red: 1, green: 1, blue: 0.8, alpha: 1)
view.device = device

// Metal set up is done in Utility.swift

// set up render pass
guard let drawable = view.currentDrawable,
  let descriptor = view.currentRenderPassDescriptor,
  let commandBuffer = commandQueue.makeCommandBuffer(),
  let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
    fatalError()
}
renderEncoder.setRenderPipelineState(pipelineState)

// drawing code here
var vertices: [float3] = [
    [-0.7, 0.8, 1],
    [-0.7, -0.4, 1],
    [0.4, 0.2, 1]
]
var matrix = matrix_identity_float4x4
let originBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<float3>.stride * vertices.count, options: [])
renderEncoder.setVertexBuffer(originBuffer, offset: 0, index: 0)
renderEncoder.setFragmentBytes(&lightGrayColor, length: MemoryLayout<float4>.stride, index: 0)
renderEncoder.setVertexBytes(&matrix,
                             length: MemoryLayout<float4x4>.stride,
                             index: 1)
renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)

let angle = Float.pi / 2.0
var distanceVector = float4(vertices.last!.x,
                            vertices.last!.y,
                            vertices.last!.z,
                            1)
var translate = matrix_identity_float4x4
translate.columns.3 = distanceVector
var rotate = matrix_identity_float4x4
rotate.columns.0 = [cos(angle), -sin(angle), 0, 0]
rotate.columns.1 = [sin(angle), cos(angle), 0, 0]
matrix = translate * rotate * translate.inverse

var transformedBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<float3>.stride * vertices.count, options: [])
renderEncoder.setVertexBuffer(transformedBuffer, offset: 0, index: 0)
renderEncoder.setFragmentBytes(&redColor, length: MemoryLayout<float4>.stride, index: 0)
renderEncoder.setVertexBytes(&matrix,
                             length: MemoryLayout<float4x4>.stride,
                             index: 1)
renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)

renderEncoder.endEncoding()
commandBuffer.present(drawable)
commandBuffer.commit()
PlaygroundPage.current.liveView = view
