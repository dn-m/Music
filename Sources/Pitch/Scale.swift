//
//  Scale.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

public struct Scale {

    // MARK: - Instance Properties

    let first: Pitch
    let intervals: IntervalPattern
}

extension Scale {

    public struct IntervalPattern {
        let intervals: [Pitch]
    }
}

extension Scale {

    // MARK: - Initializers

    init(_ first: Pitch, _ intervals: IntervalPattern) {
        self.first = first
        self.intervals = intervals
    }
}

extension Scale.IntervalPattern: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral intervals: Pitch...) {
        self.init(intervals: intervals)
    }
}
