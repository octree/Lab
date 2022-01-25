import Foundation

public struct Diff3<E: Equatable> {
    let origin: [E]
    let a: [E]
    let b: [E]

    public init(_ origin: [E], _ a: [E], _ b: [E]) {
        self.origin = origin
        self.a = a
        self.b = b
    }
}


