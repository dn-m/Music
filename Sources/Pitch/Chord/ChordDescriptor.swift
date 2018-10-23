//
//  ChordDescriptor.swift
//  Pitch
//
//  Created by James Bean on 10/23/18.
//

import DataStructures

public struct ChordDescriptor {
    let intervals: [CompoundIntervalDescriptor]
}

extension ChordDescriptor: RandomAccessCollectionWrapping {

    // MARK: - RandomAccessCollectionWrapping

    /// - Returns: The `RandomAccessCollection` base of a `ChordDescriptor`.
    public var base: [CompoundIntervalDescriptor] {
        return intervals
    }
}

extension ChordDescriptor: ExpressibleByArrayLiteral {

    // MARK: ExpressibleByArrayLiteral

    /// Creates a `ChordDescriptor` with the given array literal of `CompoundIntervalDescriptor`
    /// values.
    public init(arrayLiteral intervals: CompoundIntervalDescriptor...) {
        self.intervals = intervals
    }
}
