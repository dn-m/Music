//
//  Chord.IntervalPattern.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

extension Chord {

    // MARK: - Nested Types

    public struct IntervalPattern {
        let intervals: [Pitch]
    }
}

extension Chord.IntervalPattern: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral intervals: Pitch...) {
        self.init(intervals: intervals)
    }
}

