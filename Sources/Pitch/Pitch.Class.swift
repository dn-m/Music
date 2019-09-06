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

        /// Inversion of `Pitch.Class`.
        ///
        /// **Example Usage**
        ///
        ///     let wet: Pitch.Class = 9
        ///     let dry = wet.inversion // => 3
        ///
        ///     let dark: Pitch.Class = 4
        ///     let light = dark.inversion // => 8
        ///
        public var inversion: Pitch.Class {
            return Pitch.Class(12 - value)
        }

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



extension Pitch.Class: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of `Pitch.Class`.
    public var description: String {
        return value.description
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
