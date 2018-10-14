//
//  IntervalOrdinal.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Math

/// Interface for `IntervalOrdinal`-like values.
public protocol IntervalOrdinal {

    // MARK: - Type Properties

    /// The distance between the given `steps` and the platonic ideal for this
    /// `IntervalOrdinal` value.
    static func platonicInterval(steps: Int) -> Double

    // MARK: - Instance Properties

    /// The distance from the platonic ideal interval where the interval quality becomes diminished
    /// or augmented.
    var platonicThreshold: Double { get }

    // MARK: - Initializers

    /// Creates a `IntervalOrdinal` with the given amount of `steps`.
    init?(steps: Int)
}

