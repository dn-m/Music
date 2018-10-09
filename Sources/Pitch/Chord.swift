//
//  Chord.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

public struct Chord {

    // MARK: - Instance Properties

    let first: Pitch
    let intervals: [Pitch]
}

extension Chord {

    // MARK: - Initializers

    init(_ first: Pitch, _ intervals: [Pitch]) {
        self.first = first
        self.intervals = intervals
    }
}
