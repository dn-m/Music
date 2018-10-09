//
//  Scale.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

import DataStructures

public struct Scale {

    // MARK: - Instance Properties

    let pitches: [Pitch]
}

extension Scale {

    // MARK: - Initializers

    init(_ first: Pitch, _ intervals: IntervalPattern) {
        // TODO: Make `Pitch` a monoid to allow `accumulatingRight`
        var p = [first]
        var accum: Pitch = 0
        for i in intervals.intervals {
            accum += i
            p.append(first + accum)
        }
        self.pitches = p
    }

    init <S> (_ sequence: S) where S: Sequence, S.Element == Pitch {
        let sorted = sequence.sorted()
        precondition(!sorted.isEmpty, "Cannot create a 'Scale' with an empty sequence of pitches")
        self.init(sorted.first!, IntervalPattern(sorted.pairs.map { $1 - $0 }))
    }
}

extension Scale {

    func pitch(scaleDegree: Int) -> Pitch? {
        return pitches[safe: scaleDegree]
    }

    func scaleDegree(pitch: Pitch) -> Int? {
        return pitches.index(of: pitch)
    }
}

extension Scale: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral pitches: Pitch...) {
        self.init(pitches)
    }
}

extension Scale: Equatable { }
extension Scale: Hashable { }
