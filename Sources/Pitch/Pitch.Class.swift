//
//  Pitch.Class.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

import Math
import DataStructures

extension Pitch {

    public struct Class: NoteNumberRepresentable, PitchConvertible {

        // MARK: - Instance Properties

        /// Inversion of `Pitch.Class`.
        public var inversion: Pitch.Class {
            return Pitch.Class(12 - noteNumber.value)
        }

        /// Value of `Pitch.Class`.
        public var noteNumber: NoteNumber

        // MARK: - Initializers

        //// Create a `Pitch.Class` with a given `noteNumber`.
        public init(noteNumber: NoteNumber) {
            self.noteNumber = NoteNumber(mod(noteNumber.value, 12))
        }

        // MARK: - `PitchConvertible`

        /**
         Create a `Pitch.Class` with a `Pitch` object.

         **Example:**

         ```
         let pitch = Pitch(noteNumber: 65.5)
         Pitch.Class(pitch) // => 5.5
         ```
         */
        public init(_ pitch: Pitch) {
            self.init(noteNumber: pitch.noteNumber)
        }
    }
}

extension Pitch.Class {

    public static func + (lhs: Pitch.Class, rhs: Pitch.Class) -> Pitch.Class {
        return Pitch.Class(noteNumber: NoteNumber(lhs.noteNumber.value + rhs.noteNumber.value))
    }

    public static func - (lhs: Pitch.Class, rhs: Pitch.Class) -> Pitch.Class {
        return Pitch.Class(noteNumber: NoteNumber(lhs.noteNumber.value - rhs.noteNumber.value))
    }
}

extension Pitch.Class {

    public struct Collection: RandomAccessCollectionWrapping {

        // MARK: - Instance Properties

        /// - Returns: Each of the possible rotations for the given `Pitch.Class.Collection`.
        ///
        /// *Example Usage*
        ///
        ///     let pcs: Pitch.Class.Collection = [8,0,2,4]
        ///     let rotations = pcs.rotations // [[8,0,2,4],[0,2,4,8],[2,4,8,0],[4,8,0,2]]
        ///
        public var rotations: [Collection] {
            return base.rotations.map(Collection.init)
        }

        /// - Returns: The most "left-packed" (i.e., smaller intervals toward the beginning) of the
        /// `normalForm` and the `normalForm` of the `inversion`.
        ///
        /// *Example Usage*
        ///
        ///     let pcs: Pitch.Class.Collection = [8,0,4,6]
        ///     let primeForm = pcs.primeForm // => [0,2,4,8]
        ///
        public var primeForm: Collection {
            return [normalForm, inversion.normalForm].mostLeftPacked.reduced
        }

        /// - Returns: The the most compactly ordered representation of this
        /// `Pitch.Class.Collection`.
        ///
        /// *Example Usage*
        ///
        ///     let pcs: Pitch.Class.Collection = [8,0,4,6]
        ///     let normalForm = pcs.normalForm // => [4,6,8,0]
        ///
        public var normalForm: Collection {
            return sorted().rotations.mostCompact.mostLeftPacked
        }

        /// - Returns: A `Pitch.Class.Collection` in which each element is lowered by the amount
        /// of the first element (and thereby making the first element `0`).
        public var reduced: Collection {
            return map { $0 - first! }
        }

        /// - Returns: The inversion of this `Pitch.Class.Collection`.
        ///
        /// *Example Usage*
        ///
        ///     let webern24: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
        ///     let inversion = webern24.inversion // => [0,4,5,1,2,3,9,11,8,10,6,7]
        ///
        public var inversion: Collection {
            return map { $0.inversion }
        }

        /// - Returns: The distance between the highest and lowest elements.
        public var span: Pitch.Class {
            return last! - first!
        }

        /// Underlying storage of `Pitch.Class` values.
        public var base: [Pitch.Class]

        // MARK: - Initializers

        /// Create a `Pitch.Class.Collection` with the given `pitchClasses`.
        ///
        /// *Example Usage*
        ///
        ///     let webern24: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
        ///     let webern27: Pitch.Class.Collection = [0,8,7,11,10,9,3,1,4,2,6,5]
        ///
        public init <C> (_ pitchClasses: C) where C: Swift.Collection, C.Element == Pitch.Class {
            precondition(!pitchClasses.isEmpty)
            self.base = Array(pitchClasses)
        }

        /// - Returns: A `Pitch.Class.Collection` in which each element is updated by the given
        /// `transform`.
        public func map (_ transform: (Element) -> Element) -> Collection {
            return Collection(base.map(transform))
        }

        /// - Returns: A `Pitch.Class.Collection` in which the elements are sorted by the given
        /// `areInIncreasingOrder`.
        public func sorted(
            by areInIncreasingOrder: (Pitch.Class, Pitch.Class) throws -> Bool
            ) rethrows -> Collection
        {
            return Collection(try base.sorted(by: areInIncreasingOrder))
        }

        /// - Returns: A `Pitch.Class.Collection` in which the elements are sorted from low to high.
        public func sorted() -> Collection {
            return sorted(by: <)
        }
    }
}

extension Pitch.Class.Collection: Equatable { }

extension Pitch.Class.Collection: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Pitch.Class...) {
        self.base = elements
    }
}

extension Collection where Element == Pitch.Class.Collection {

    /// - Returns: The `Pitch.Class.Collection` values which have the least difference from the last
    /// element to the first element.
    var mostCompact: [Pitch.Class.Collection] {
        return min(property: { $0.span })
    }

    /// - Returns: The `Pitch.Class.Collection` which has the least difference between its first
    /// elements.
    var mostLeftPacked: Pitch.Class.Collection {
        return self.min { $0.intervals.lexicographicallyPrecedes($1.intervals) }!
    }
}

extension Collection where Element: NoteNumberRepresentable {

    public var intervals: [OrderedInterval<Element>] {
        return pairs.map(OrderedInterval.init)
    }

    public var dyads: [Dyad<Element>] {
        return subsets(cardinality: 2).map(Dyad.init)
    }
}

extension BidirectionalCollection {
    var rotations: [[Element]] {
        let values = Array(self)
        return (0..<values.count).map { values.rotated(by: $0) }
    }
}
