//
//  Dyad.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

import Algorithms

/// An ordered pair of `NoteNumberRepresentable`-conforming type values.
///
/// **Example Usage**
///
///     let good = Dyad(Pitch(60),Pitch(69))
///     let bad = Dyad(Pitch(60),Pitch(66))
///     let ugly = Dyad(Pitch(60,Pitch(65.5))
///
public struct Dyad <Element: NoteNumberRepresentable> {

    // MARK: - Instance Types

    /// The lower `NoteNumberRepresentable`-conforming type value.
    public let lower: Element

    /// The higher `NoteNumberRepresentable`-conforming type value.
    public let higher: Element
}

extension Dyad {

    // MARK: - Computed Properties

    /// - Returns: The `OrderedInterval` of these two `NoteNumberRepresentable`-conforming type
    /// values.
    public var interval: OrderedInterval<Element> {
        return OrderedInterval(lower,higher)
    }
}

extension Dyad {

    // MARK: - Initializers

    /// Creates a `Dyad` with the two `NoteNumberRepresentable`-conforming type values.
    ///
    /// The values are ordered automatically.
    ///
    /// **Example Usage**
    ///
    ///     let inOrder = Dyad(Pitch(60),Pitch(61)) // => (60,61)
    ///     let outOfOrder = Dyad(Pitch(61),Pitch(60)) //=> (60,61)
    ///
    public init(_ a: Element, _ b: Element) {
        (lower, higher) = ordered(a, b)
    }
}

extension Dyad: Equatable { }
extension Dyad: Hashable { }

extension Dyad: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printed description of a `Dyad`.
    public var description: String {
        return "(\(lower), \(higher))"
    }
}
