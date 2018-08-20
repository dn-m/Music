//
//  Pitch.swift
//  Pitch
//
//  Created by James Bean on 3/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Math

/// The quality of a sound governed by the rate of vibrations producing it.
public struct Pitch: NoteNumberRepresentable {

    // MARK: - Instance Properties

    /// The `NoteNumber` representation of this `Pitch`.
    public let value: NoteNumber

    // MARK: - Initializers

    /// Creates a `Pitch` with the given `NoteNumber` value.
    public init(_ value: NoteNumber) {
        self.value = value
    }

}

extension Pitch {

    // MARK: Computed Properties

    /// - Returns: The `mod 12` representation of this `Pitch`.
    public var `class`: Pitch.Class {
        return Pitch.Class(value)
    }
}

extension Pitch {

    // MARK: - Instance Methods

    /// The `Frequency` representation of this `Pitch`, with the given tuning `referenceFrequency`
    /// at the given `referenceNoteNumber`.
    public func frequency(with referenceFrequency: Frequency, referenceNoteNumber: NoteNumber)
        -> Frequency
    {
        return value.frequency(with: referenceFrequency, at: referenceNoteNumber)
    }
}

extension Pitch: Equatable { }
extension Pitch: Hashable { }
