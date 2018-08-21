//
//  Frequency.swift
//  Pitch
//
//  Created by James Bean on 3/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import DataStructures
import Math

/// Periodic vibration in Hertz.
///
/// **Example Usage**
///
///     let nice = Frequency(440.0) // => "a 440"
///     let mean: Frequency = 440.0 // => "a 440"
///
public struct Frequency: NewType, SignedNumeric {

    // MARK: - Instance Properties

    /// The value of this `Frequency` in Hz (i.e., cycles per second).
    public let value: Double

    // MARK: - Initializers

    /// Creates a `Frequency` with the given `value` in Hz (i.e., cycles per second).
    public init(value: Double) {
        self.value = value
    }
}

extension Frequency {

    // MARK: - Conversion to Frequency

    /// Creates a `Frequency` from the given `noteNumber`, using the given reference `Frequency` for
    /// the given reference `NoteNumber`.
    public init(noteNumber: NoteNumber, with freqRef: Frequency = 440, at nnRef: NoteNumber) {
        self.value = freqRef.value * pow(2.0, (nnRef.value - 69.0) / 12.0)
    }

    /// - Returns: A `NoteNumber` representation of this `Frequency`, using the given reference
    /// `Frequency` for the given reference `NoteNumber`.
    public func noteNumber(with freqRef: Frequency = 440, at nnRef: NoteNumber = 69) -> NoteNumber {
        return NoteNumber(frequency: self, with: freqRef, at: nnRef)
    }
}

extension Frequency {

    // MARK: - Just Intonation

    /// Creates a `Frequency` with the given `ratio` and the given `reference` `Frequency`.
    public init(_ ratio: Fraction, reference: Frequency) {
        self.value = ratio.doubleValue * reference.value
    }
}

extension Frequency: Equatable { }
extension Frequency: Hashable { }
