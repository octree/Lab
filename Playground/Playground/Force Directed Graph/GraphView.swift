import SwiftUI

class GraphViewModel: ObservableObject {
    @Published var nodes: [PositionedGraphNode<Node>] = Node.create(depth: 4, branches: 4).positioned
    private var index = 0
    public init() {}

    public func layout() {
        DispatchQueue.global().async {
            var nodes = self.nodes
            (0..<8).forEach { _ in Layout().layout3(&nodes) }
            DispatchQueue.main.async {
                self.nodes = nodes
            }
        }
    }
}

struct GraphView: View {
    @StateObject private var viewModel = GraphViewModel()
    var body: some View {
        TimelineView(.periodic(from: Date(), by: 0.02)) { _ in
            let _ = viewModel.layout()
            Canvas { context, _ in
                viewModel.nodes.draw(in: &context)
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}

extension Array where Element == PositionedGraphNode<Node> {
    func draw(in context: inout GraphicsContext) {
        let min = reduce(CGPoint.zero) {
            .init(x: Swift.min($0.x, $1.position.x), y: Swift.min($0.y, $1.position.y))
        }
        context.translateBy(x: -min.x + 20, y: -min.y + 20)
        drawLines(in: &context)
        forEach { $0.render(in: &context) }
    }

    private func drawLines(in context: inout GraphicsContext) {
        var map: [String: CGPoint] = [:]
        forEach { map[$0.node.value] = $0.position }
        for node in self {
            let start = node.position
            for edge in node.node.edges {
                let end = map[edge.value]!
                var path = Path()
                path.addLines([start, end])
                context.stroke(path, with: .color(.pink))
            }
        }
    }
}

public extension PositionedGraphNode where T == Node {
    func render(in context: inout GraphicsContext) {
        switch node.shape {
        case let .circle(radius: radius):
            let rect = CGRect(origin: position, size: .zero).insetBy(dx: -radius, dy: -radius)
            context.fill(Path(ellipseIn: rect), with: .color(.pink))
            context.draw(Text(node.value), at: position)
        case let .rectange(size: size):
            let rect = CGRect(origin: position, size: .zero).insetBy(dx: -size.width / 2, dy: -size.height / 2)
            context.fill(Path(rect), with: .color(.pink))
            context.draw(Text(node.value), at: position)
        }
    }
}

public struct Layout {
    public var springLength: CGFloat = 60
    public var springStrength: CGFloat = 0.1
    public var repulsionStrength: CGFloat = 3600

    func layout3(_ graph: inout [PositionedGraphNode<Node>]) {
        for index in graph.indices {
            let node = graph[index]
            for otherIndex in (index + 1)..<graph.count {
                guard otherIndex != index else { continue }
                let other = graph[otherIndex]
                let vect = other.position - node.position
                let springDistance = vect.distance // - nodeLen - otherLen
                let distance = max(1, vect.distance)
                var force = -repulsionStrength / (distance * distance)
                if node.hasEdge(other) {
                    force += (springDistance - springLength) * springStrength
                }
                let normalized = vect != .zero ? vect * (1 / vect.distance) : randomDirection()
                graph[index].position += normalized * force
                graph[otherIndex].position -= normalized * force
            }
        }
    }

    private func randomDirection() -> CGVector {
        let angle = Double.random(in: 0...(.pi))
        return CGVector(dx: sin(angle), dy: cos(angle))
    }
}
