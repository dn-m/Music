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

    // MARK: - Initializers

    init(_ first: Pitch, _ intervals: IntervalPattern) {
        self.first = first
        self.intervals = intervals
    }
}
