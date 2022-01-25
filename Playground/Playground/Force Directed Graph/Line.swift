//
//  LineSegment.swift
//  Prelude
//
//  Created by Octree on 2021/11/23.
//
//  Copyright (c) 2021 Octree <octree@octree.me>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
import Foundation
import CoreGraphics

public struct LineSegment: Equatable {
    public var from: CGPoint
    public var to: CGPoint
}

public extension LineSegment {
    func nearestPoint(to point: CGPoint) -> CGPoint {
        guard let function = LinearFunction(point1: from, point2: to) else {
            let (bottom, top) = from.y < to.y ? (from, to) : (to, from)
            if bottom.y > point.y {
                return bottom
            } else if top.y < point.y {
                return top
            }
            return CGPoint(x: bottom.x, y: point.y)
        }
        let (left, right) = from.x < to.x ? (from, to) : (to, from)
        let foot = function.footOfPerpendicular(through: point)
        if foot.x < left.x {
            return left
        } else if foot.x > right.x {
            return right
        }
        return foot
    }
}

public extension CGRect {
    var topLineSegment: LineSegment {
        LineSegment(from: CGPoint(x: minX, y: minY), to: CGPoint(x: maxX, y: minY))
    }

    var leftLineSegment: LineSegment {
        LineSegment(from: CGPoint(x: minX, y: minY), to: CGPoint(x: minX, y: maxY))
    }

    var bottomLineSegment: LineSegment {
        LineSegment(from: CGPoint(x: minX, y: maxY), to: CGPoint(x: maxX, y: maxY))
    }

    var rightLineSegment: LineSegment {
        LineSegment(from: CGPoint(x: maxX, y: minY), to: CGPoint(x: maxX, y: maxY))
    }

    var lineSegments: [LineSegment] { [topLineSegment, leftLineSegment, bottomLineSegment, rightLineSegment] }
}

public extension LineSegment {
    /// The intersection point with another line segment
    ///
    /// https://stackoverflow.com/a/1968345
    ///
    /// - Parameter another: Another line segment
    /// - Returns: The intersection point. return nil if not exists.
    func intersectionPoint(with another: LineSegment) -> CGPoint? {
        let v1 = to - from
        let v2 = another.to - another.from
        let a = (-v2.dx * v1.dy + v1.dx * v2.dy)
        let s = (-v1.dy * (from.x - another.from.x) + v1.dx * (from.y - another.from.y)) / a
        let t = (v2.dx * (from.y - another.from.y) - v2.dy * (from.x - another.from.x)) / a
        if s >= 0, s <= 1, t >= 0, t <= 1 {
            return CGPoint(x: from.x + t * v1.dx, y: from.y + t * v1.dy)
        }
        return nil
    }

    var boundingBox: CGRect {
        let (minX, maxX) = from.x < to.x ? (from.x, to.x) : (to.x, from.x)
        let (minY, maxY) = from.y < to.y ? (from.y, to.y) : (to.y, from.y)
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}
