//
//  Chord.IntervalPattern.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

import DataStructures

extension Chord {

    // MARK: - Nested Types

    /// The pattern of intervals which defines the quality of a `Chord`.
    public struct IntervalPattern {

        // MARK: - Instance Properties

        let intervals: [Pitch]
    }
}

extension Chord.IntervalPattern {

    // MARK: - Initializers

    /// Creates a `Chord` with the given pitch intervals.
    public init(_ intervals: [Pitch]) {
        self.init(intervals: intervals)
    }
}

extension Chord.IntervalPattern {

    // MARK: - Type Properties

    /// Major chord interval pattern.
    static let major: Chord.IntervalPattern = [4,3]

    /// Minor chord interval pattern.
    static let minor: Chord.IntervalPattern = [3,4]

    // TODO: Add more helpers
}

extension Chord.IntervalPattern: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    /// Creates a `Chord.IntervalPattern` with the given array literal of `Pitch` values.
    public init(arrayLiteral intervals: Pitch...) {
        self.init(intervals: intervals)
    }
}

// FIXME: Reinstate Chord.IntervalPattern: CollectionWrapping when https://bugs.swift.org/browse/SR-11048 if fixed.
//extension Chord.IntervalPattern: CollectionWrapping {
//
//    // MARK: - CollectionWrapping
//
//    /// - Returns: The `Collection` base of a `Chord.IntervalPattern`.
//    public var base: [Pitch] {
//        return intervals
//    }
//}

extension Chord.IntervalPattern: Equatable { }
extension Chord.IntervalPattern: Hashable { }
