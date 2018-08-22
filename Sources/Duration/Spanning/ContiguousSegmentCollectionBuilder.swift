//
//  ContiguousSegmentCollectionBuilder.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

// FIXME: Move to `dn-m/Structure`

import Algebra
import DataStructures
import Math

/// Interface for types which can build `ContiguousSegmentCollection` types.
public protocol ContiguousSegmentCollectionBuilder: class {

    // MARK: - Associated Types

    /// Type of product which is built by `ContiguousSegmentCollectionBuilder`.
    associatedtype Product: ContiguousSegmentCollection

    /// Segment-type contained by the `Product`.
    typealias Spanner = Product.Segment

    // MARK: - Instance Properties

    /// Intermediate storage which is converted into the `Product`.
    //
    // FIXME: Consider using `OrderedDictionary` re: performance.
    var intermediate: OrderedDictionary<Spanner.Metric,Spanner> { get set }

    /// Cumulative offset of spanners contained in `intermediate`.
    var offset: Spanner.Metric { get set }

    // MARK: - Instance Methods

    /// Adds the given `Segment` to the `intermediate`.
    func add(_: Spanner) -> Self

    /// Creates the final `Product`.
    func build() -> Product
}

extension ContiguousSegmentCollectionBuilder {

    /// Adds the given `element` to the `intermediate` with accumulating offsets.
    ///
    /// - Returns: `Self`.
    @discardableResult public func add(_ element: Spanner) -> Self {
        intermediate.append(element, key: offset)
        offset = offset + element.range.length
        return self
    }

    /// Adds each of the given `elements` to the `intermediate` with accumulating offsets.
    ///
    /// - Returns: `Self`.
    @discardableResult public func add <S: Sequence> (_ elements: S) -> Self
        where S.Element == Spanner
    {
        elements.forEach { _ = add($0) }
        return self
    }

    /// Creates the final `Product` with the `intermediate`.
    public func build() -> Product {
        return Product(SortedDictionary(intermediate.map { $0 }))
    }
}
