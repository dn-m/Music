//
//  IntervalSearchTree.swift
//  MusicModel
//
//  Created by James Bean on 9/2/18.
//

import Algebra
import DataStructures
import Math

/// The composition of information (the interval and payload) of a node in an `IntervalSearchTree`.
/// This is the information which augments the information normally held by an `AVLTree`.
public struct ISTPayload <Metric: Comparable, Value> {

    /// The interval in which the `payload` occurs.
    let interval: Range<Metric>

    /// The maximum upper bound of subtrees.
    var max: Metric

    /// The payload contained herein.
    var payload: Value

    /// Creates an `ISTPayload` with the given `interval`, `value`, and `max` values.
    public init(interval: Range<Metric>, value: Value, max: Metric? = nil) {
        self.interval = interval
        self.payload = value
        self.max = max ?? interval.upperBound
    }
}

extension ISTPayload: Equatable where Value: Equatable { }

public typealias IntervalSearchTree <Metric: Comparable, Value> = AVLTree<Metric,ISTPayload<Metric,Value>>

// FIXME: This is a very concrete initial implementation. Abstract out from here.
extension AVLTree where Key == Fraction, Value == ISTPayload<Fraction,[AttributeID]> {

    /// Creates an `IntervalSearchTree` with the given `sequence` of `ISTPayload` values.
    public init <S> (_ sequence: S) where S: Sequence, S.Element == ISTPayload<Fraction,[AttributeID]> {
        self.init()
        sequence.forEach { insert($0, forKey: $0.interval.lowerBound) }
    }

    public func intervals(overlapping target: Range<Fraction>) -> [ISTPayload<Fraction,[AttributeID]>] {
        var result: [ISTPayload<Fraction,[AttributeID]>] = []
        return IntervalSearchTree.intervals(from: root, overlapping: target, into: &result)
    }

    private static func intervals(
        from node: Node? = nil,
        overlapping target: Range<Fraction>,
        into result: inout [ISTPayload<Fraction,[AttributeID]>]
    ) -> [ISTPayload<Fraction,[AttributeID]>]
    {
        guard let node = node else { return result }
        let interval = node.value.interval
        // Attempt to add the payload of the current node if their is an overlap
        if IntervalRelation.overlapping.contains(interval.relation(with: target)) {
            result.append(node.value)
        }
        // Attempt to add nodes to the left if the maximum subtree upper bound is greater than the
        // lower bound of the target interval
        if let left = node.left, left.value.max > target.lowerBound {
            result = intervals(from: left, overlapping: target, into: &result)
        }
        // Lastly, attempt to add the overlapping intervals to the right
        result = intervals(from: node.right, overlapping: target, into: &result)
        return result
    }

    mutating func insert(_ payload: Value) {
        self.root = IntervalSearchTree.insert(payload, forKey: payload.interval.lowerBound, into: root)
    }

    @discardableResult
    private static func insert(_ value: Value, forKey key: Key, into node: Node? = nil) -> Node? {
        guard let node = node else { return Node(key: key, value: value) }
        if node.key > key {
            node.left = insert(value, forKey: key, into: node.left)
        } else if node.key < key {
            node.right = insert(value, forKey: key, into: node.right)
        } else {
            // If the interval already exists, append the values to extant interval node.
            node.value.payload.append(contentsOf: value.payload)
            return node
        }
        // Update the max subtree upper bound to the max of the current and the inserted
        node.value.max = max(node.value.max, value.max)
        return balance(node, with: key)
    }
}

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
