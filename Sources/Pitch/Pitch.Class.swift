//
//  Pitch.Class.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

import Math
import DataStructures
import Algebra

extension Pitch {

    // MARK: - Nested Types

    /// A `Pitch` viewed within a modulo-12 space.
    public struct Class: NoteNumberRepresentable {

        // MARK: - Instance Properties

        /// Value of `Pitch.Class`.
        public var value: NoteNumber

        // MARK: - Initializers

        /// Create a `Pitch.Class` with a given `noteNumber`.
        ///
        /// > If the given `noteNumber` is not in the range `[0,12)`, it will be updated to the mod 12
        /// equivalent value.
        ///
        public init(_ noteNumber: NoteNumber) {
            self.value = NoteNumber(mod(noteNumber.value, 12))
        }
    }
}

extension Pitch.Class: AdditiveGroup {

    /// Inversion of `Pitch.Class`.
    ///
    /// **Example Usage**
    ///
    ///     let wet: Pitch.Class = 9
    ///     let dry = wet.inverse // => 3
    ///
    ///     let dark: Pitch.Class = 4
    ///     let light = dark.inverse // => 8
    ///
    public var inverse: Pitch.Class { return Pitch.Class(12 - value) }

    @available(*, deprecated, message: "Use `Pitch.Class.inverse` instead")
    public var inversion: Pitch.Class {
        return inverse
    }

    /// - Returns: The difference between two `Pitch.Class` values.
    public static func - (lhs: Pitch.Class, rhs: Pitch.Class) -> Pitch.Class {
        return Pitch.Class(lhs.value - rhs.value)
    }

    /// - Returns: The inverse of a given `Pitch.Class` value.
    public static prefix func - (_ element: Pitch.Class) -> Pitch.Class {
        return Pitch.Class(12 - element.value)
    }
}

extension Pitch.Class: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of `Pitch.Class`.
    public var description: String {
        return value.description
    }
}

extension Pitch.Class: Comparable {

    // MARK: - Comparable

    /// - Returns: `true` if the value on the left is less than the value on the `right`.
    public static func < (lhs: Pitch.Class, rhs: Pitch.Class) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Pitch.Class: Equatable { }
extension Pitch.Class: Hashable { }

extension Collection where Element: NoteNumberRepresentable {

    /// - Returns: The intervals between each adjacent pair of pitches contained herein.
    public var intervals: [OrderedInterval<Element>] {
        return pairs.map(OrderedInterval.init)
    }

    /// - Returns: The dyads between each pitch and each other pitch contained herein.
    public var dyads: [Dyad<Element>] {
        return subsets(cardinality: 2).map(Dyad.init)
    }
}

extension Dyad {

    /// Creates a `Dyad` with an array of `NoteNumberRepresentable`-conforming type elements.
    fileprivate init(_ elements: [Element]) {
        assert(elements.count == 2)
        let (a,b) = (elements[0], elements[1])
        self.init(a,b)
    }
}

extension BidirectionalCollection {
    var rotations: [[Element]] {
        let values = Array(self)
        return (0..<values.count).map { values.rotated(by: $0) }
    }
}
