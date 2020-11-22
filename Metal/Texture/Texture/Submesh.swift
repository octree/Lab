import MetalKit

class Submesh {
    struct Textures {
        let baseColor: MTLTexture?
    }
    var mtkSubmesh: MTKSubmesh
    var textures: Textures
    
    init(mdlSubmesh: MDLSubmesh, mtkSubmesh: MTKSubmesh) {
        self.mtkSubmesh = mtkSubmesh
        textures = .init(material: mdlSubmesh.material)
    }
}

extension Submesh: Texturable {
}

private extension Submesh.Textures {
    init(material: MDLMaterial?) {
        func property(with semantic: MDLMaterialSemantic) -> MTLTexture? {
            guard let property = material?.property(with: semantic),
                  property.type == .string,
                  let fileName = property.stringValue,
                  let texture = try? Submesh.loadTexture(imageName: fileName) else {
                return nil
            }
            return texture
        }
        baseColor = property(with: .baseColor)
    }
}
