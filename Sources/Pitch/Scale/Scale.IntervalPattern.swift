//
//  Scale.IntervalPattern.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

extension Scale {

    public struct IntervalPattern {
        let intervals: [Pitch]
    }
}

extension Scale.IntervalPattern: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral intervals: Pitch...) {
        self.init(intervals: intervals)
    }
}
