//
//  Chord.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

import Destructure
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

    init <S> (_ sequence: S) where S: Sequence, S.Element == Pitch {
        let sorted = sequence.sorted()
        precondition(!sorted.isEmpty, "Cannot create a 'Chord' with an empty sequence of pitches")
        self.init(sorted.first!, IntervalPattern(sorted.pairs.map { $1 - $0 }))
    }
}

extension Chord: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral pitches: Pitch...) {
        self.init(pitches)
    }
}

extension Chord: Equatable { }
extension Chord: Hashable { }
