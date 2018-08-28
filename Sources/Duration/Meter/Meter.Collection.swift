//
//  Meter.Collection.swift
//  Duration
//
//  Created by James Bean on 8/27/18.
//

import DataStructures
import Math

extension Meter {

    // MARK: - Nested Types

    /// A collection of contiguous `Meter` values indexed by their fractional offset.
    ///
    /// **Example Usage**
    ///
    /// You can create a `Meter.Collection` in several different ways:
    ///
    /// With an array literal of `Meter` values:
    ///
    ///     let _: Meter.Collection = [Meter(3,4), Meter(5,16), Meter(5,8)]
    ///
    /// With the standard initializer:
    ///
    ///     let _ = Meter.Collection([Meter(3,4), Meter(5,16), Meter(5,8)])
    ///
    /// You can also add an fractional offset, if needed:
    ///
    ///     let _ = Meter.Collection([Meter(3,4), Meter(5,16), Meter(5,8)], offset: Fraction(3,64))
    ///
    /// Lastly, you can construct a `Meter.Collection` over time with a `MeterCollectionBuilder`:
    ///
    ///     let _ = MeterCollectionBuilder(offset: Fraction(21,16)
    ///         .add(Meter(3,4)
    ///         .add(Meter(2,4)
    ///         .add(Meter(5,8)
    ///         .add(Meter(13,64)
    ///         .add(Meter(7,16)
    ///         .build()
    ///
    /// To get a fragment of a `Meter.Collection`, supply a desired range:
    ///
    ///     let meters: Meter.Collection = [Meter(4,4), Meter(3,4), Meter(5,4)]
    ///     let range = Fraction(7,16) ..< Fraction(31,16)
    ///     let fragment = meters.fragment(in: range)
    ///
    /// This will return a collection of `Meter.Fragment` values in the given rage.
    ///
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
    public init(offset: Fraction = .zero) {
        self.intermediate = [:]
        self.offset = offset
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
