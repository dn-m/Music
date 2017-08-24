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
    public var intervals: [OrderedInterval<Iterator.Element>] {
        return Array(self).pairs.map(OrderedInterval.init)
    }

    // TODO: Make lazy
    public var dyads: [Dyad<Iterator.Element>] {
        return Array(self).subsets(cardinality: 2).map(Dyad.init)
    }
}

extension Array where Element == Pitch.Class {

    /// Normal form of a Pitch.Class segment
    public var normalForm: [Pitch.Class] {

        let values = map { $0.noteNumber.value }.sorted()
        let rotations: [[Double]] = (0..<count).map { amount in
            values.rotated(by: amount).denormalizedForIntervalComparison
        }

        // The sequence that is most compact (least distance between last and first elements)
        let compact = rotations.extrema(property: { $0.span }, areInIncreasingOrder: <)

        // The sequence that has the smallest interval at the beginning
        let leftPacked = mostLeftPacked(compact)
        return leftPacked.map(Pitch.Class.init)
    }

    public var primeForm: [Pitch.Class] {
        guard !isEmpty else { return [] }
        let transposed = normalForm.map { $0 - normalForm.first! }
        let inverse = transposed.map { $0.inversion }.normalForm
        let it = inverse.map { $0 - inverse.first! }.map { $0.noteNumber.value }
        return mostLeftPacked([transposed.map { $0.noteNumber.value }, it]).map(Pitch.Class.init)
    }
}

// Make generic over Numeric
func mostLeftPacked(_ values: [[Double]]) -> [Double] {
    assert(!values.isEmpty)
    guard values.count > 1 else { return values.first! }
    return values.sorted { $0.intervals.lexicographicallyPrecedes($1.intervals) }.first!
}

// Change Double to Pitch.Class
extension Array where Element == Double {

    // Adds 12 to each value if it is less than previous (which occurs for the last n values of
    // of an ordered pitch class set rotated n times)
    private var denormalizedForIntervalComparison: [Double] {
        return reduce([]) { accum, cur in
            // FIMXE: Refactor to one-liner
            if let last = accum.last {
                let normalized = cur < last ? cur + 12 : cur
                return accum + [normalized]
            } else {
                return accum + [cur]
            }
        }
    }

    var intervals: [Double] {
        return pairs.map { $1 - $0 }
    }

    // Invariant: self is sorted, is not empty
    private var span: Double {
        return last! - first!
    }
}


