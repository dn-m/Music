//
//  IntervalSearchTree.swift
//  MusicModel
//
//  Created by James Bean on 9/2/18.
//

import DataStructures

enum IntervalSearchTree <Metric: SignedNumeric & Comparable, Value> {

    // MARK: - Cases

    case empty
    case leaf(Node)
    indirect case branch(IntervalSearchTree, Node, IntervalSearchTree)
}

extension IntervalSearchTree {

    // MARK: - Nested Types

    struct Node {

        /// The interval containing the payload.
        let interval: Range<Metric>

        /// The maximum endpoint contained by subtrees
        let max: Metric

        /// The payload contained herein.
        let value: Value

        init(value: Value, interval: Range<Metric> , max: Metric) {

            self.value = value
            self.interval = interval
            self.max = max
        }
    }
}

extension IntervalSearchTree {

    // MARK: - Initializers

    /// Creates an `IntervalSearchTree` with the given `sequence` of value-interval pairs.
    init <S> (_ sequence: S) where S: Sequence, S.Element == (Value,Range<Metric>) {
        var tree: IntervalSearchTree = .empty
        sequence.forEach { tree = tree.inserting($0, in: $1) }
        self = tree
    }
}

extension IntervalSearchTree {

    // MARK: - Computed Properties

    // FIXME: Using `0` as the minimum if there is no enty. This is problematic for ranges with
    // <0 bounds.
    var max: Metric? {
        switch self {
        case .empty:
            return nil
        case .leaf(let node):
            return node.max
        case .branch(let left, let node, let right):
            return Swift.max(left.max ?? 0, node.max, right.max ?? 0)
        }
    }

    var inOrder: [Node] {
        typealias Result = [Node]
        func traverse(_ node: IntervalSearchTree, into result: inout Result) {
            switch node {
            case .empty:
                break
            case .leaf(let node):
                result.append(node)
            case .branch(let left, let node, let right):
                result = left.inOrder + node + right.inOrder
            }
        }
        var result = Result()
        traverse(self, into: &result)
        return result
    }
}

extension IntervalSearchTree {

    // MARK: - Instance Methods

    // FIXME: This implementation does not enfore balancing.
    // FIXME: Implement AVL balancing.
    // FIXME: Consider using medial-oriented
    func inserting(_ value: Value, in interval: Range<Metric>) -> IntervalSearchTree {
        switch self {
        case .empty:
            let node = Node(value: value, interval: interval, max: interval.upperBound)
            return .leaf(node)
        case .leaf(let node):
            let newMax = Swift.max(interval.upperBound, node.interval.upperBound)
            let leaf = Node(value: value, interval: interval, max: interval.upperBound)
            let newNode = Node(value: node.value, interval: node.interval, max: newMax)
            if interval.lowerBound < node.interval.lowerBound {
                return .branch(.leaf(leaf), newNode, .empty)
            } else {
                return .branch(.empty, newNode, .leaf(leaf))
            }
        case .branch(let left, let node, let right):
            let newMax = Swift.max(interval.upperBound, node.max)
            let newNode = Node(value: node.value, interval: node.interval, max: newMax)
            if interval.lowerBound < node.interval.lowerBound {
                return .branch(left.inserting(value, in: interval), newNode, right)
            } else {
                return .branch(left, newNode, right.inserting(value, in: interval))
            }
        }
    }

    func contains(_ target: Metric) -> Bool {
        return search(for: target) != nil
    }

    /// - Returns: The highest node (closest to the root) which contains the given `target`.
    func search(for target: Metric) -> IntervalSearchTree? {
        switch self {
        case .empty:
            return nil
        case .leaf(let node):
            return node.contains(target) ? self : nil
        case .branch(let left, let node, let right):
            if node.contains(target) { return self }
            if target < node.interval.lowerBound {
                return left.search(for: target)
            } else {
                return right.search(for: target)
            }
        }
    }

    // TODO: intervalsOverlapping(with interval: Range<Metric>) -> Set<Range<Metric>>
}

extension IntervalSearchTree: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    init(arrayLiteral elements: (Value,Range<Metric>)...) {
        self.init(elements)
    }
}

extension IntervalSearchTree.Node {
    func contains(_ target: Metric) -> Bool {
        return interval.contains(target)
    }
}

extension IntervalSearchTree.Node: Equatable where Value: Equatable { }
extension IntervalSearchTree: Equatable where Value: Equatable { }
