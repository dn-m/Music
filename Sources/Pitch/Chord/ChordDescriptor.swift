//
//  ChordDescriptor.swift
//  Pitch
//
//  Created by James Bean on 10/23/18.
//

import DataStructures

/// Description of a simultaneity of pitches wherein the intervals between the pitches are
/// described.
///
/// **Example Usage**
///
///     let minor: ChordDescriptor = [.M3, .m3]
///     let major: ChordDescriptor = [.m3, .M3]
///     let diminished: ChordDescriptor = [.m3, .m3]
///     let augmented: ChordDescriptor = [.M3, .M3]
///
public struct ChordDescriptor {

    // MARK: - Instance Properties

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
