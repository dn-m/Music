//
//  Meter.Collection.swift
//  Duration
//
//  Created by James Bean on 8/27/18.
//

import DataStructures
import Math

extension Meter {

    // MARK: - Associated Types

    /// A collection of contiguous `Meter` values indexed by their fractional offset.
    public typealias Collection = ContiguousSegmentCollection<Meter>
}

/// Stateful building of a `Meter.Collection`.
public final class MeterCollectionBuilder {

    // MARK: - Associated Types
    
    /// The end product of this `Meter.Collection.Builder`.
    public typealias Product = Meter.Collection

    // MARK: - Instance Properties
    /// The value which will ultimately be the underlying storage of a `Meter.Collection`.
    public var intermediate: OrderedDictionary<Fraction,Meter>

    /// The accumulating offset of `Fraction` keys.
    public var offset: Fraction

    // MARK: - Initializers
    /// Create an empty `Meter.Collection.Builder` ready to help you build up a
    /// `Meter.Collection`.
    public init() {
        self.intermediate = [:]
        self.offset = .zero
    }

    /// Adds the given `element` to the `intermediate` with accumulating offsets.
    ///
    /// - Returns: `Self`.
    @discardableResult public func add(_ element: Meter) -> MeterCollectionBuilder {
        intermediate.append(element, key: offset)
        offset = offset + element.length
        return self
    }

    /// Adds each of the given `elements` to the `intermediate` with accumulating offsets.
    ///
    /// - Returns: `Self`.
    @discardableResult public func add <S: Sequence> (_ elements: S) -> Self
        where S.Element == Meter
    {
        elements.forEach { _ = add($0) }
        return self
    }

    /// Creates the final `Product` with the `intermediate`.
    public func build() -> Product {
        return Product(SortedDictionary(intermediate.map { $0 }))
    }
}

