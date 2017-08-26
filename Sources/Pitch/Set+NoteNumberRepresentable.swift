//
//  Set+NoteNumberRepresentable.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

import Math

extension Collection where Element: NoteNumberRepresentable {

    // TODO: Make lazy
    // FIXME: Should not need to create `Array` (audit `pairs`)
    public var intervals: [OrderedInterval<Iterator.Element>] {
        return pairs.map(OrderedInterval.init)
    }

    // TODO: Make lazy
    // FIXME: Should not need to create `Array` (audit `pairs`)
    public var dyads: [Dyad<Iterator.Element>] {
        return subsets(cardinality: 2).map(Dyad.init)
    }
}

// FIXME: Elevate this into own type, with assertion on init
extension Collection where Element == Pitch.Class {

    /// - Returns: The Prime Form
    public var primeForm: [Pitch.Class] {
        guard !isEmpty else { return map { $0 } }
        return mostLeftPacked([normalForm, inversion.normalForm]).reduced
    }

    /// Normal form of a Pitch.Class segment
    public var normalForm: [Pitch.Class] {
        return mostLeftPacked(mostCompact(sorted().rotations))
    }

    // FIXME: Lift `rotated` to Collection rather than Array
    private var rotations: [[Pitch.Class]] {
        let values = Array(self)
        return (0..<values.count).map { values.rotated(by: $0) }
    }

    /// Transpose the set such that the first value is `0`.
    public var reduced: [Pitch.Class] {
        assert(count > 0)
        return map { $0 - first! }
    }

    public var inversion: [Pitch.Class] {
        return map { $0.inversion }
    }
}

extension BidirectionalCollection where Element == Pitch.Class {

    // Invariant: self is sorted, is not empty
    var span: Pitch.Class {
        assert(count > 0)
        return last! - first!
    }
}

func mostCompact(_ values: [[Pitch.Class]]) -> [[Pitch.Class]] {
    return values.extrema(property: { $0.span }, areInIncreasingOrder: <)
}

// TODO: Return array or arrays, not single array (dont call `.first!` at end)
func mostLeftPacked(_ values: [[Pitch.Class]]) -> [Pitch.Class] {
    assert(!values.isEmpty)
    guard values.count > 1 else { return values.first! }
    return values.sorted { $0.intervals.lexicographicallyPrecedes($1.intervals) }.first!
}
