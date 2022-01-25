import CoreGraphics

// MARK: - CGRect and Size

public extension CGRect {
    var center: CGPoint {
        return origin + CGVector(dx: width, dy: height) / 2.0
    }
}

public func +(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width + right, height: left.height + right)
}

public func -(left: CGSize, right: CGFloat) -> CGSize {
    return left + (-1.0 * right)
}

// MARK: - CGPoint and CGVector math

public func -(left: CGPoint, right: CGPoint) -> CGVector {
    return CGVector(dx: left.x - right.x, dy: left.y - right.y)
}

public func /(left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(dx: left.dx / right, dy: left.dy / right)
}

public func *(left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(dx: left.dx * right, dy: left.dy * right)
}

public func *(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

public func +(left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

public func +=(left: inout CGPoint, right: CGVector) {
    left.x += right.dx
    left.y += right.dy
}

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func +(left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

public func -(left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

public func -=(left: inout CGVector, right: CGVector) {
    left.dx -= right.dx
    left.dy -= right.dy
}

public func +=(left: inout CGVector, right: CGVector) {
    left.dx += right.dx
    left.dy += right.dy
}

public func +(left: CGVector?, right: CGVector?) -> CGVector? {
    if let left = left, let right = right {
        return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    } else {
        return nil
    }
}

public func -(left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

public func -=(left: inout CGPoint, right: CGVector) {
    left.x -= right.dx
    left.y -= right.dy
}

public extension CGPoint {
    init(_ vector: CGVector) {
        self.init()
        x = vector.dx
        y = vector.dy
    }
}

public extension CGVector {
    init(_ point: CGPoint) {
        self.init()
        dx = point.x
        dy = point.y
    }

    func applying(_ transform: CGAffineTransform) -> CGVector {
        return CGVector(CGPoint(self).applying(transform))
    }

    func rounding(toScale scale: CGFloat) -> CGVector {
        return CGVector(dx: CoreGraphics.round(dx * scale) / scale,
                        dy: CoreGraphics.round(dy * scale) / scale)
    }

    var quadrance: CGFloat {
        return dx * dx + dy * dy
    }

    var normal: CGVector? {
        if !(dx.isZero && dy.isZero) {
            return CGVector(dx: -dy, dy: dx)
        } else {
            return nil
        }
    }

    /// CGVector pointing in the same direction as self, with a length of 1.0 - or nil if the length is zero.
    var normalized: CGVector? {
        let quadrance = self.quadrance
        if quadrance > 0.0 {
            return self / sqrt(quadrance)
        } else {
            return nil
        }
    }
}

public extension CGPoint {
    func middle(to another: CGPoint) -> CGPoint {
        CGPoint(x: (x + another.x) / 2,
                y: (y + another.y) / 2)
    }
}

public extension CGVector {
    var norm: CGFloat {
        sqrt(dx * dx + dy * dy)
    }

    var distance: CGFloat {
        sqrt(dx * dx + dy * dy)
    }
}

public extension CGVector {
    func cos(to another: CGVector) -> CGFloat {
        (dx * another.dx + dy * another.dy) / (norm * another.norm)
    }
}

public extension CGPoint {
    func minus(_ another: CGPoint) -> CGPoint {
        CGPoint(x: x - another.x, y: y - another.y)
    }

    // to origin (.zero)
    var distance: CGFloat {
        sqrt(x * x + y * y)
    }
}
