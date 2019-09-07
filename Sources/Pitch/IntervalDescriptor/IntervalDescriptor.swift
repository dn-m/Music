//
//  IntervalDescriptor.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

/// Interface for intervals between two `Pitch` values.
public protocol IntervalDescriptor {

    // MARK: - Associated Types

    /// The `IntervalOrdinal`-conforming type for this `IntervalDescriptor`.
    associatedtype Ordinal: IntervalOrdinal

    // MARK: - Type Properties

    /// Unison interval descriptor.
    static var unison: Self { get }

    // MARK: - Initializers

    /// Creates a `IntervalDescriptor` with the given `quality` and the given `ordinal`.
    init(_ quality: IntervalQuality, _ ordinal: Ordinal)


}
