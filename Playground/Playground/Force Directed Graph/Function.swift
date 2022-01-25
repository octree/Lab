import Foundation
import CoreGraphics

public struct LinearFunction: Equatable {
    public var k: Double
    public var b: Double

    public init(k: Double, b: Double) {
        self.k = k
        self.b = b
    }

    public init?(point1: CGPoint, point2: CGPoint) {
        guard point1.x != point2.x else { return nil }
        self.k = (point1.y - point2.y) / (point1.x - point2.x)
        self.b = point1.y - k * point1.x
    }

    public func apply(x: Double) -> Double {
        k * x + b
    }

    public func callAsFunction(_ x: Double) -> Double {
        apply(x: x)
    }
}

public extension LinearFunction {
    func perpendicularLineFunction(through point: CGPoint) -> LinearFunction? {
        guard k != 0 else { return nil }
        let k2 = -1 / k
        let b2 = point.y - k2 * point.x
        return .init(k: k2, b: b2)
    }

    func footOfPerpendicular(through point: CGPoint) -> CGPoint {
        guard let function = perpendicularLineFunction(through: point) else {
            return CGPoint(x: point.x, y: b)
        }
        return intersectionPoint(with: function)!
    }

    func intersectionPoint(with another: LinearFunction) -> CGPoint? {
        guard k != another.k else { return nil }
        let x = (another.b - b) / (k - another.k)
        let y = apply(x: x)
        return CGPoint(x: x, y: y)
    }
}
