//
//  Scale.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

import Algebra
import DataStructures

/// Ordered sequence of pitch intervals.
///
/// A `Scale` may or may not be octave invariant, and it may or may not be infinitely protracting.
///
/// **Example Usage**
///
///     let cMajor: Scale = [0,2,4,5,7,9,11]
///     let cSharpWholeTone = Scale(1, [2,2,2,2,2,2])
///     let gHarmonicMinor = Scale(7, .harmonicMinor)
///
public struct Scale {

    // MARK: - Instance Properties

    /// The root (lowest) pitch of this `Scale.`
    public let root: Pitch

    /// The intervals which comprise this `Scale`.
    public let intervals: IntervalPattern
}

extension Scale {

    // MARK: - Computed Properties

    /// - Returns: `true` if the intervals contained herein span 12 semitones. Otherwise, `false`.
    public var isOctaveInvariant: Bool {
        return intervals.span == 12
    }
}

extension Scale {

    // MARK: - Initializers

    /// Creates a `Scale` with the given `first` pitch and the given `intervals`.
    init(_ root: Pitch, _ intervals: IntervalPattern) {
        self.root = root
        self.intervals = intervals
    }

    /// Creates a `Scale` with the pitches in the given `sequence`.
    init <S> (_ sequence: S) where S: Sequence, S.Element == Pitch {
        let sorted = sequence.sorted()
        guard let first = sorted.first else {
            fatalError("Cannot create a 'Scale' with an empty sequence of pitches")
        }
        self.init(first, IntervalPattern(sorted.pairs.map { $1 - $0 }))
    }
}

extension Scale {

    /// - Returns: The `Pitch` at the given `scaleDegree`, if it exists. Otherwsie, `nil`.
    ///
    /// - Note: The scale degree `1` corresponds to the `root` pitch.
    ///
    /// - TODO: Build out `ScaleDegree` to a fully-fledged type.
    func pitch(scaleDegree: Int) -> Pitch? {
        let target = scaleDegree - 1
        for (index,pitch) in enumerated() {
            if !intervals.isLooping && pitch > intervals.span + root { return nil }
            if target == index { return pitch }
        }
        return nil
    }

    /// - Returns: The scale degree for the given `pitch`, if it exists. Otherwise, `nil`.
    ///
    /// - Note: The scale degree `1` corresponds to the `root` pitch.
    ///
    /// - TODO: Build out `ScaleDegree` to a fully-fledged type.
    func scaleDegree(pitch target: Pitch) -> Int? {
        for (index,pitch) in enumerated() {
            if !intervals.isLooping || pitch > intervals.span + root { return nil }
            if pitch == target { return index + 1 }
        }
        return nil
    }
}

extension Scale: Sequence {

    // MARK: - Sequence

    public func makeIterator() -> AnyIterator<Pitch> {
        var index = 0
        var accum: Pitch = 0
        return AnyIterator {
            defer { index += 1 }
            guard let interval = self.intervals[index] else { return nil }
            defer { accum += interval }
            return self.root + accum
        }
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
