//
//  OrderedInterval.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

/// The ordered interval between two `NoteNumberRepresentable`-conforming type values.
public struct OrderedInterval <Element: NoteNumberRepresentable>: NoteNumberRepresentable {

    // MARK: - Instance Properties

    /// The underlying `NoteNumber` value for this `OrderedInterval`.
    public let value: NoteNumber

    // MARK: - Initializers

    /// Creates an `OrderedInterval` with the given `noteNumber` value.
    public init(_ noteNumber: NoteNumber) {
        self.value = noteNumber
    }

    /// Creates an `OrderedInterval` between the two given `NoteNumberRepresentable`-conforming
    /// type values.
    ///
    /// **Example Usage**
    ///
    ///     let ray: Pitch = 62
    ///     let tea: Pitch = 59
    ///     let _ = OrderedInterval(ray,tea) // => -3
    ///
    public init(_ a: Element, _ b: Element) {
        self.value = (b - a).value
    }
}
