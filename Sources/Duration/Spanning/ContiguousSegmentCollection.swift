//
//  ContiguousSegmentCollection.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

// FIXME: Move to `dn-m/Structure`

import Algebra
import DataStructures
import Math

/// Interface for values that contain a sequence of `SpanningFragment` type values.
public protocol ContiguousSegmentCollection: RandomAccessCollectionWrapping, Spanning, Fragmentable
    where Metric == Spanner.Metric
{

    // MARK: - Associated Types

    /// Type of value contained herein.
    associatedtype Spanner: SpanningFragment

    // MARK: - Instance Properties

    /// Backing storage of spanners.
    var base: SortedDictionary<Metric,Spanner> { get }

    // MARK: - Initializers

    /// Creates a `ContiguousSegmentCollection` with a pre-built internal representation of spanners.
    init(_: SortedDictionary<Metric,Spanner>)

    /// Creates a `ContiguousSegmentCollection` with a sequence of spanners.
    init <S> (_: S) where S: Sequence, S.Element == Spanner
}

extension ContiguousSegmentCollection {

    /// `SpanningContainer` with no spanners.
    public static var empty: Self { return Self([]) }

    /// - Returns: An array of spanners in the given `range` of indices.
    public subscript(range: CountableClosedRange<Int>) -> [Spanner] {
        return range.map { base.values.map { $0 }[$0] }
    }

    /// - Returns: A collection of the offsets of each spanner contained herein.
    public var offsets: AnyCollection<Metric> {
        return AnyCollection(base.keys)
    }

    /// - Returns: A collection of the spanners contained herein.
    public var spanners: AnyCollection<Spanner> {
        return AnyCollection(base.values)
    }

    /// Length of `SpanningContainer`.
    public var length: Metric {
        return base.values.map { $0.length }.sum
    }

    /// - Returns: `true` if the given `target` is contained within the `length` of 
    /// `SpanninerContainer`. Otherwise, `false`.
    public func contains(_ target: Metric) -> Bool {
        return (.zero ..< length).contains(target)
    }

    /// - Returns: New `ContiguousSegmentCollection` in the given `range` of metrics.
    public subscript (range: Range<Metric>) -> Self {

        assert(range.lowerBound >= .zero)

        guard range.lowerBound < length else {
            return .empty
        }

        let range = range.upperBound > length ? range.lowerBound ..< length : range
        guard let startIndex = indexOfElement(containing: range.lowerBound) else {
            return .empty
        }

        let endIndex = indexOfElement(containing: range.upperBound, includingUpperBound: true)
            ?? base.count - 1

        if endIndex == startIndex {
            let (offset, element) = base[startIndex]
            return .init([element[range.lowerBound - offset ..< range.upperBound - offset]])
        }

        let start = spanner(from: range.lowerBound, at: startIndex)
        let end = spanner(to: range.upperBound, at: endIndex)

        if endIndex == startIndex + 1 {
            return .init([start,end])
        }

        let innards = self[startIndex + 1 ... endIndex - 1]
        return .init(start + innards + end)
    }

    /// - Returns: Spanner at the given `index`, spanning from the given (global) `offset` to its
    /// upper bound.
    public func spanner(from offset: Metric, at index: Int) -> Spanner {
        let (elementOffset, fragment) = base[index]
        return fragment.from(offset - elementOffset)
    }

    /// - Returns: Spanner at the given `index`, spanning from its lower bound, to the given 
    /// (global) offset.
    public func spanner(to offset: Metric, at index: Int) -> Spanner {
        let (elementOffset, fragment) = base[index]
        return fragment.to(offset - elementOffset)
    }

    /// - Parameters:
    ///   - includingUpperBound: Whether or not to include the `upperBound` of the `element.range`
    ///     in the search, and to dismiss the `lowerBound`.
    ///
    /// - Returns: The index of the element containing the given `target` offset.
    ///
    // FIXME: It feels gross to have to duplicate this code.
    public func indexOfElement(containing target: Metric, includingUpperBound: Bool = false)
        -> Int?
    {

        var start = 0
        var end = base.count

        while start < end {

            let mid = start + (end - start) / 2
            let (offset, element) = base[mid]
            let lowerBound = offset
            let upperBound = offset + element.range.length
            if includingUpperBound {
                if target > lowerBound && target <= upperBound {
                    return mid
                } else if target > upperBound {
                    start = mid + 1
                } else {
                    end = mid
                }
            } else {
                if target >= lowerBound && target < upperBound {
                    return mid
                } else if target >= offset + element.range.length {
                    start = mid + 1
                } else {
                    end = mid
                }
            }
        }
        
        return nil
    }
}
