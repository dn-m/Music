//
//  Pitch.Class.Collection.swift
//  Pitch
//
//  Created by James Bean on 9/6/19.
//

extension Pitch.Class {

    // MARK: - Nested Types

    /// A non-empty collection of `Pitch.Class` elements.
    ///
    /// **Example Usage**
    ///
    /// Create a `Pitch.Class.Collection` with an array literal of integer literals.
    ///
    ///     let webern24: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
    ///
    /// Perform post-tonal theoretical operations on a `Pitch.Class.Collection`.
    ///
    ///     let pcs: Pitch.Class.Collection = [8,0,4,6]
    ///     let inversion = pcs.inversion // => [4,0,8,6]
    ///     let retrograde = pcs.retrograde // => [6,4,0,8]
    ///     let normalForm = pcs.normalForm // => [4,6,8,0]
    ///     let primeForm = pcs.primeForm // => [0,2,4,8]
    ///
    public struct Collection {

        // MARK: - Instance Properties

        /// - Returns: Each of the possible rotations for the given `Pitch.Class.Collection`.
        ///
        /// **Example Usage**
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
        /// **Example Usage**
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
        /// **Example Usage**
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
        /// **Example Usage**
        ///
        ///     let webern24: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
        ///     let inversion = webern24.inversion // => [0,1,9,8,4,5,3,7,6,11,10,2]
        ///
        /// - TODO: Make a function which takes an axis over which pcs are inverted.
        public var inversion: Collection {
            return map { $0.inverse }
        }

        /// - Returns: The retrograde of this `Pitch.Class.Collection`.
        ///
        /// **Example Usage**
        ///
        ///     let webern24: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
        ///     let retrograde = webern24.retrograde // => [10,2,1,6,5,9,7,8,4,3,11,0]
        ///
        public var retrograde: Collection {
            return Collection(reversed())
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
        /// **Example Usage**
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
        public func sorted(by areInIncreasingOrder: (Pitch.Class, Pitch.Class) throws -> Bool)
            rethrows -> Collection
        {
            return Collection(try base.sorted(by: areInIncreasingOrder))
        }

        /// - Returns: A `Pitch.Class.Collection` in which the elements are sorted from low to high.
        public func sorted() -> Collection {
            return sorted(by: <)
        }
    }
}

// FIXME: Reinstate RandomAccessCollectionWrapping conformance SR-11084"
extension Pitch.Class.Collection: RandomAccessCollection {

    // MARK: - RandomAccessCollection

    public typealias Base = [Pitch.Class]

    /// Start index.
    ///
    /// - Complexity: O(1)
    ///
    public var startIndex: Base.Index {
        return base.startIndex
    }

    /// End index.
    ///
    /// - Complexity: O(1)
    ///
    public var endIndex: Base.Index {
        return base.endIndex
    }

    /// First element, if there is at least one element. Otherwise, `nil`.
    ///
    /// - Complexity: O(1)
    ///
    public var first: Base.Element? {
        return base.first
    }

    /// Last element, if there is at least one element. Otherwise, `nil`.
    ///
    /// - Complexity: O(1)
    ///
    public var last: Base.Element? {
        return base.last
    }

    /// Amount of elements.
    ///
    /// - Complexity: O(1)
    ///
    public var count: Int {
        return base.count
    }

    /// - Returns: `true` if there are no elements contained herein. Otherwise, `false`.
    ///
    /// - Complexity: O(1)
    ///
    public var isEmpty: Bool {
        return base.isEmpty
    }

    /// - Returns: The element at the given `index`.
    ///
    /// - Complexity: O(1)
    ///
    public subscript(position: Base.Index) -> Base.Element {
        return base[position]
    }

    /// - Returns: Index after the given `index`.
    ///
    /// - Complexity: O(1)
    public func index(after index: Base.Index) -> Base.Index {
        return base.index(after: index)
    }

    /// - Returns: Index before the given `index`.
    ///
    /// - Complexity: O(1)
    ///
    public func index(before index: Base.Index) -> Base.Index {
        return base.index(before: index)
    }
}

extension Pitch.Class.Collection: Equatable { }

extension Pitch.Class.Collection: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    /// Create a `Pitch.Class.Collection` with an array literal.
    public init(arrayLiteral elements: Pitch.Class...) {
        self.base = elements
    }
}

extension Collection where Element == Pitch.Class.Collection {

    /// - Returns: The `Pitch.Class.Collection` values which have the least difference from the last
    /// element to the first element.
    var mostCompact: [Element] {
        return min(property: { $0.span })
    }

    /// - Returns: The `Pitch.Class.Collection` which has the least difference between its first
    /// elements.
    var mostLeftPacked: Element {
        return self.min { $0.lazy.intervals.lexicographicallyPrecedes($1.lazy.intervals) }!
    }
}
