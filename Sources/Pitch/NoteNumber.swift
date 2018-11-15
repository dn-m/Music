//
//  NoteNumber.swift
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

/// Floating point analog to the MIDI note number.
///
/// Similarly to the MIDI note number, "middle c" is represented as `60`. Each octave is represented
/// by a distance of `12`, thus `48` is the "c below middle c", and `72` is the "c above middle c".
///
/// **Example Usage**
///
///     let warm = NoteNumber(60)
///     let cold: NoteNumber = 60
///
public struct NoteNumber:
    NewType,
    Comparable,
    SignedNumeric,
    ExpressibleByFloatLiteral,
    ExpressibleByIntegerLiteral
{
    // MARK: - Instance Properties

    /// The value of a note number (a floating point analog to the MIDI note number).
    public let value: Double

    // MARK: - Initializers

    /// Creates a `NoteNumber` with the given `value`.
    public init(value: Double) {
        self.value = value
    }
}

extension NoteNumber {

    // MARK: - Conversion to NoteNumber

    /// Creates a `NoteNumber` from the given `frequency`, using the given reference `Frequency` for
    /// the given reference `NoteNumber`.
    public init(frequency: Frequency, with freqRef: Frequency = 440, at nnRef: NoteNumber = 69) {
        self.value = nnRef.value + (12 * (log(frequency.value / freqRef.value) / log(2)))
    }

    /// - Returns: A `Frequency` representation of this `NoteNumber`, using the given reference
    /// `Frequency` for the given reference `NoteNumber`.
    public func frequency(with freqRef: Frequency, at nnRef: NoteNumber) -> Frequency {
        return Frequency(noteNumber: self, with: freqRef, at: nnRef)
    }
}

extension NoteNumber: Equatable { }
extension NoteNumber: Hashable { }

extension NoteNumber: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of `NoteNumber`.
    public var description: String {
        return value.description
    }
}
