//
//  Pitch.Class.Collection.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

import Algorithms
import DataStructures
import Math

extension Pitch.Class {

    public struct Collection: RandomAccessCollectionWrapping {

        // MARK: - Instance Properties

        public var rotations: [Collection] {
            return base.rotations.map(Collection.init)
        }

        public var primeForm: Collection {
            return [normalForm, inversion.normalForm].mostLeftPacked.reduced
        }

        public var normalForm: Collection {
            return sorted().rotations.mostCompact.mostLeftPacked
        }

        public var reduced: Collection {
            return map { $0 - first! }
        }

        public var inversion: Collection {
            return map { $0.inversion }
        }

        public var span: Pitch.Class {
            return last! - first!
        }

        public var base: [Pitch.Class]

        // MARK: - Initializers

        public init <C> (_ pitchClasses: C) where C: Swift.Collection, C.Element == Pitch.Class {
            precondition(!pitchClasses.isEmpty)
            self.base = Array(pitchClasses)
        }

        public func map (_ transform: (Element) -> Element) -> Collection {
            return Collection(base.map(transform))
        }

        public func sorted(
            by areInIncreasingOrder: (Pitch.Class, Pitch.Class) throws -> Bool
        ) rethrows -> Collection
        {
            return Collection(try base.sorted(by: areInIncreasingOrder))
        }

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
    var mostCompact: [Pitch.Class.Collection] {
        return extrema(property: { $0.span }, areInIncreasingOrder: <)
    }

    var mostLeftPacked: Pitch.Class.Collection {
        return sorted { $0.intervals.lexicographicallyPrecedes($1.intervals) }.first!
    }
}

func mostCompact(_ values: [Pitch.Class.Collection]) -> [Pitch.Class.Collection] {
    return values.extrema(property: { $0.span }, areInIncreasingOrder: <)
}

// TODO: Return array or arrays, not single array (dont call `.first!` at end)
func mostLeftPacked(_ values: [[Pitch.Class]]) -> [Pitch.Class] {
    assert(!values.isEmpty)
    guard values.count > 1 else { return values.first! }
    return values.sorted { $0.intervals.lexicographicallyPrecedes($1.intervals) }.first!
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

