//
//  Chord.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

import DataStructures

public struct Chord {

    // MARK: - Instance Properties

    let first: Pitch
    let intervals: IntervalPattern
}

extension Chord {

    // MARK: - Nested Types

    public struct IntervalPattern {
        let intervals: [Pitch]
    }
}

extension Chord {

    // MARK: - Initializers

    init(_ first: Pitch, _ intervals: IntervalPattern) {
        self.first = first
        self.intervals = intervals
    }
}

extension Chord.IntervalPattern: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral intervals: Pitch...) {
        self.init(intervals: intervals)
    }
}
