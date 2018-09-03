//
//  IntervalSearchTree.swift
//  MusicModel
//
//  Created by James Bean on 9/2/18.
//

// FIXME: Rename!
public struct ISTNode <Metric: Comparable, Value> {
    let interval: Range<Metric>
    let value: Value
    public init(interval: Range<Metric>, value: Value) {
        self.interval = interval
        self.value = value
    }
}

public typealias IntervalSearchTree <Metric: Comparable, Value> = AVLTree<Metric,ISTNode<Metric,Value>>
