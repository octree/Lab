import Foundation
import CoreGraphics

public protocol GraphNode {
    var edges: [Self] { get }
    func hasEdge(_ edge: Self) -> Bool
    func connect(to edge: Self)
}

public struct PositionedGraphNode<T: MeasurableGraphNode> {
    public internal(set) var position: CGPoint = .zero
    public var node: T

    init(position: CGPoint = .zero, node: T) {
        self.position = position
        self.node = node
    }

    public func hasEdge(_ edge: PositionedGraphNode<T>) -> Bool {
        node.hasEdge(edge.node)
    }
}

public enum NodeShape {
    case circle(radius: CGFloat)
    case rectange(size: CGSize)
}

public protocol MeasurableGraphNode: GraphNode {
    var shape: NodeShape { get }
}


public extension NodeShape {
    func intersectionLineDistance(center: CGPoint, directionTo another: CGPoint) -> CGFloat {
        switch self {
        case .circle(let radius):
            return radius
        case .rectange(let size):
            let x = center.x - size.width / 2
            let y = center.y - size.height / 2
            let rect = CGRect(origin: CGPoint(x: x, y: y), size: size)
            guard another != center else { return min(size.width, size.height) }
            let vector = another - center
            let normalized = vector * (1 / vector.distance)
            let end = center + normalized * max(size.width, size.height)
            let line = LineSegment(from: center, to: end)
            let point = rect.lineSegments.compactMap { $0.intersectionPoint(with: line) }.first!
            return (point - center).distance
        }
    }
}
