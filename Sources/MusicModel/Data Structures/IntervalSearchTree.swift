//
//  IntervalSearchTree.swift
//  MusicModel
//
//  Created by James Bean on 9/2/18.
//

import Algebra
import Math

protocol PayloadHolding {
    associatedtype Value
    var value: Value { get set }
}

/// The composition of information (the interval and payload) of a node in an `IntervalSearchTree`.
/// This is the information which augments the information normally held by an `AVLTree`.
public struct ISTNode <Metric: Comparable, Value>: PayloadHolding {
    let interval: Range<Metric>
    var value: Value
    public init(interval: Range<Metric>, value: Value) {
        self.interval = interval
        self.value = value
    }
}

public typealias IntervalSearchTree <Metric: Comparable, Value> = AVLTree<Metric,ISTNode<Metric,Value>>

// FIXME: This is a very concrete initial implementation. Abstract out from here.
extension AVLTree where Key == Fraction, Value == ISTNode<Fraction,[Any]> {
    @discardableResult
    private static func insert(_ value: Value, forKey key: Key, into node: Node? = nil) -> Node? {
        guard let node = node else { return Node(key: key, value: value) }
        if node.key > key {
            node.left = insert(value, forKey: key, into: node.left)
        } else if node.key < key {
            node.right = insert(value, forKey: key, into: node.right)
        } else {
            node.value.value.append(contentsOf: value.value)
            return node
        }
        return balance(node, with: key)
    }
}

