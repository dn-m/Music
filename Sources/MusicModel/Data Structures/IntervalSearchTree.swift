//
//  IntervalSearchTree.swift
//  MusicModel
//
//  Created by James Bean on 9/2/18.
//

import Algebra
import DataStructures
import Math

/// An `IntervalSearchTree` is an augmentatin of an `AVLTree`, wherein the the value of `Node` is
/// an `IntervalSearchTree.Node`. An `IntervalSearchTree.Node` contains the `interval`
/// indexing the payload, the `max` upper bound of subtrees, and the `payload` value itself.
///
/// - TODO: Push down to dn-m/Structure/DataStructures when fully vetted.
public struct IntervalSearchTree <Metric: Comparable, Value> {

    /// Underlying `AVLTree` augmented for interval searching purposes.
    public typealias Base = AVLTree<Metric,Node>

    public struct Node {

        /// The payload contained herein.
        public var payload: Value

        /// The interval in which the `payload` occurs.
        public let interval: Range<Metric>

        /// The maximum upper bound of subtrees.
        @usableFromInline
        var max: Metric

        /// Creates an `ISTPayload` with the given `interval`, `value`, and `max` values.
        @inlinable
        public init(interval: Range<Metric>, value: Value, max: Metric? = nil) {
            self.interval = interval
            self.payload = value
            self.max = max ?? interval.upperBound
        }
    }

    /// Underlying `AVLTree` augmented for interval searching purposes.
    @usableFromInline
    var base: Base
}

extension IntervalSearchTree {

    // MARK: - Initializers

    /// Creates an empty `IntervalSearchTree`.
    public init() {
        self.base = .init()
    }

    /// Creates an `IntervalSearchTree` with the given `sequence` of `Payload` values.
    @inlinable
    public init <S> (_ sequence: S) where S: Sequence, S.Element == Node {
        self.init()
        for payload in sequence { insert(payload) }
    }
}

extension IntervalSearchTree {

    public static var empty: IntervalSearchTree {
        return .init()
    }
}

extension IntervalSearchTree {

    /// - Returns: An `IntervalSearchTree` composed of the nodes overlapping the given `interval`.
    public subscript(interval: Range<Metric>) -> IntervalSearchTree {
        return IntervalSearchTree(overlapping(interval))
    }
}

extension IntervalSearchTree {

    // MARK: - Instance Methods

    /// - Returns: An array of payloads containing the fractional interval and associated values
    /// containing the given `target` offset.
    @inlinable
    public func containing(_ target: Metric) -> [Node] {
        var result: [Node] = []
        IntervalSearchTree.intervals(from: base.root, containing: target, into: &result)
        return result
    }

    // FIXME: Make free func
    @usableFromInline
    static func intervals(
        from node: Base.Node? = nil,
        containing target: Metric,
        into result: inout [Node]
    )
    {
        guard let node = node else { return }
        let interval = node.value.interval
        if interval.contains(target) { result.append(node.value) }
        if let left = node.left, left.value.max > target {
            intervals(from: node.left, containing: target, into: &result)
        }
        intervals(from: node.right, containing: target, into: &result)
    }

    /// - Returns: An array of payloads containing the fractional interval and associated values
    /// overlapping with the given `target` interval.
    //
    // FIXME: Return an `IntervalSearchTree` which retains its structure, instead of just an array
    // of nodes.
    @inlinable
    public func overlapping(_ target: Range<Metric>) -> [Node] {
        var result: [Node] = []
        IntervalSearchTree.intervals(from: base.root, overlapping: target, into: &result)
        return result
    }

    // FIXME: Return an `IntervalSearchTree` which retains its structure, instead of just an array
    // of nodes.
    @usableFromInline
    static func intervals(
        from node: Base.Node? = nil,
        overlapping target: Range<Metric>,
        into result: inout [Node]
    )
    {
        guard let node = node else { return }
        let interval = node.value.interval
        // Attempt to add the payload of the current node if their is an overlap
        if IntervalRelation.overlapping.contains(interval.relation(with: target)) {
            result.append(node.value)
        }
        // Attempt to add nodes to the left if the maximum subtree upper bound is greater than the
        // lower bound of the target interval
        if let left = node.left, left.value.max > target.lowerBound {
            intervals(from: left, overlapping: target, into: &result)
        }
        // Lastly, attempt to add the overlapping intervals to the right
        intervals(from: node.right, overlapping: target, into: &result)
    }

    /// Inserts the given `payload`, storing the payload by the lower bound of its interval.
    @inlinable
    public mutating func insert(_ payload: Node) {
        self.base.root = IntervalSearchTree.insert(payload,
            forKey: payload.interval.lowerBound,
            into: base.root
        )
    }

    @discardableResult
    @usableFromInline
    static func insert(_ value: Node, forKey key: Metric, into node: Base.Node? = nil)
        -> Base.Node?
    {
        guard let node = node else { return Base.Node(key: key, value: value) }
        if node.key > key {
            node.left = insert(value, forKey: key, into: node.left)
        } else if node.key < key {
            node.right = insert(value, forKey: key, into: node.right)
        } else {
            // If the interval already exists, insert the values to extant interval node.
            return node
        }
        // Update the max subtree upper bound to the max of the current and the inserted
        node.value.max = max(node.value.max, value.max)
        return Base.balance(node, with: key)
    }
}

extension IntervalSearchTree where Value: SetAlgebra {

    /// - Returns: An array of payloads containing the fractional interval and associated values
    /// overlapping with the given `target` interval.
    //
    // FIXME: Return an `IntervalSearchTree` which retains its structure, instead of just an array
    // of nodes.
    @inlinable
    public func overlapping(_ target: Range<Metric>) -> [Node] {
        var result: [Node] = []
        IntervalSearchTree.intervals(from: base.root, overlapping: target, into: &result)
        return result
    }

    @discardableResult
    @usableFromInline
    static func insert(_ value: Node, forKey key: Metric, into node: Base.Node? = nil)
        -> Base.Node?
    {
        guard let node = node else { return Base.Node(key: key, value: value) }
        if node.key > key {
            node.left = insert(value, forKey: key, into: node.left)
        } else if node.key < key {
            node.right = insert(value, forKey: key, into: node.right)
        } else {
            // If the interval already exists, insert the values to extant interval node.
            node.value.payload.formUnion(value.payload)
            return node
        }
        // Update the max subtree upper bound to the max of the current and the inserted
        node.value.max = max(node.value.max, value.max)
        return Base.balance(node, with: key)
    }
}

extension IntervalSearchTree.Node: Equatable where Value: Equatable { }
extension IntervalSearchTree: Equatable where Value: Equatable { }

extension IntervalRelation {

    // TODO: Add to `IntervalRelation` declaration in `dn-m/Structure/DataStructures`
    static var overlapping: [IntervalRelation] = [
        .overlaps,
        .overlappedBy,
        .finishedBy,
        .finishes,
        .contains,
        .containedBy,
        .starts,
        .startedBy,
        .equals
    ]
}
