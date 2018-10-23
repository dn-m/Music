//
//  Chord.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

import Destructure
import DataStructures

/// Collection of pitches.
///
/// **Example usage**
///
///     let cMajor: Chord = [60,64,67]
///     let gMinor: Chord = [67,70,74]
///
public struct Chord {

    // MARK: - Instance Properties

    let pitches: [Pitch]
}

extension Chord {

    // MARK: - Initializers

    /// Creates a `Chord` with the given `first` pitch and the given `intervals`.
    init(_ lowest: Pitch, _ intervals: IntervalPattern) {
        self.pitches = [lowest] + intervals.accumulatingSum.map { $0 + lowest }
    }

    /// Creates a `Chord` with the pitches in the given `sequence`.
    init <S> (_ sequence: S) where S: Sequence, S.Element == Pitch {
        let sorted = sequence.sorted()
        precondition(!sorted.isEmpty, "Cannot create a 'Chord' with an empty sequence of pitches")
        self.init(sorted.first!, IntervalPattern(sorted.pairs.map { $1 - $0 }))
    }
}

extension Chord: RandomAccessCollectionWrapping {

    // MARK: - RandomAccessCollectionWrapping

    /// - Returns: The `RandomAccessCollection` of `Pitch` values contained herein.
    public var base: [Pitch] {
        return pitches
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
