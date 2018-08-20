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

public struct NoteNumber:
    NewType,
    Comparable,
    SignedNumeric,
    ExpressibleByFloatLiteral,
    ExpressibleByIntegerLiteral
{
    // MARK: - Instance Properties

    public let value: Double

    // MARK: - Initializers

    public init(value: Double) {
        self.value = value
    }
}

extension NoteNumber {

    // MARK: - Conversion to NoteNumber

    /// Creates a `NoteNumber` from the given `frequency`, using the given reference `Frequency` for
    /// the given reference `NoteNumber`.
    public init(frequency: Frequency, with freqRef: Frequency = 440, at nnRef: NoteNumber) {
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
