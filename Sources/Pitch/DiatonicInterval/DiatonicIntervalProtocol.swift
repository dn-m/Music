//
//  DiatonicIntervalProtocol.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

/// Interface for intervals between two `Pitch` values.
public protocol DiatonicIntervalProtocol {

    // MARK: - Associated Types

    /// The `DiatonicIntervalNumber`-conforming type for this `DiatonicIntervalProtocol`.
    associatedtype Number: DiatonicIntervalNumber

    /// IntervalQuality value of a `OrderedIntervalDescriptor`.
    ///
    /// (e.g., `.diminished`, `.minor`, `.perfect`, `.major`, `.augmented`).
    typealias Quality = DiatonicIntervalQuality

    // MARK: - Type Properties

    /// Unison interval descriptor.
    static var unison: Self { get }

    // MARK: - Initializers

    /// Creates a `DiatonicIntervalProtocol` with the given `quality` and the given `number`.
    init(_ quality: Quality, _ ordinal: Number)
}
