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

    // MARK: - Initializers

    init(_ first: Pitch, _ intervals: IntervalPattern) {
        self.first = first
        self.intervals = intervals
    }
}
