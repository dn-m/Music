//
//  UnorderedInterval.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

import Algorithms

/// The unordered interval between two `NoteNumberRepresentable`-conforming type values.
public struct UnorderedInterval <Element: NoteNumberRepresentable>: NoteNumberRepresentable {

    // MARK: - Instance Properties

    /// The underlying `NoteNumber` value for this `UnorderedInterval`.
    public let value: NoteNumber

    // MARK: - Initializers

    /// Creates an `UnorderedInterval` with the given `noteNumber` value.
    public init(_ noteNumber: NoteNumber) {
        self.value = noteNumber
    }

    /// Creates an `UnorderedInterval` between the two given `NoteNumberRepresentable`-conforming
    /// type values.
    ///
    /// **Example Usage**
    ///
    ///     let dough: Pitch = 60
    ///     let may: Pitch = 63
    ///     let _ = UnorderedInterval(dough,may) // => 3
    ///
    ///     let soul: Pitch = 67
    ///     let lay: Pitch = 56
    ///     let _ = UnorderedInterval(soul,lay) // => 11
    ///
    public init(_ a: Element, _ b: Element) {
        let (a,b) = ordered(a,b)
        self.value = (b - a).value
    }
}
