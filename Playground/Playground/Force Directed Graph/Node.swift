import Foundation
import CoreGraphics

public final class Node: GraphNode {
    public var edges: [Node]
    public var value: String
    private var _shape: NodeShape

    public init(value: String, edges: [Node] = []) {
        self.edges = edges
        self.value = value
        _shape = .circle(radius: 20)
    }

    public func hasEdge(_ edge: Node) -> Bool {
        edges.contains(edge)
    }

    public func connect(to edge: Node) {
        edges.append(edge)
    }
}

extension Node: Equatable {
    public static func ==(_ lhs: Node, _ rhs: Node) -> Bool {
        lhs.value == rhs.value
    }
}

let ranges = [0x1F600...0x1F64F, // Emoticons
              0x1F300...0x1F5FF, // Misc Symbols and Pictographs
]

var emojis = ranges.flatMap { $0.compactMap { UnicodeScalar($0).map { String($0) } } }

private func getName() -> String {
    return emojis.removeFirst()
}

public extension Node {
    static func create(depth: Int, branches: Int) -> [Node] {
        var graph = [Node(value: getName())]
        if depth > 1 {
            for _ in 0 ..< branches {
                let sub = create(depth: depth - 1, branches: branches)
                sub[0].connect(to: graph[0])
                graph[0].connect(to: sub[0])
                graph.append(contentsOf: sub)
            }
        }
        return graph
    }
}

extension Array where Element == Node {
    var positioned: [PositionedGraphNode<Node>] {
        map { PositionedGraphNode(position: CGPoint(x: .random(in: 0...100), y: .random(in: 0...100)), node: $0) }
    }
}


extension Node: MeasurableGraphNode {
    public var shape: NodeShape { _shape }
}
