//
//  DiatonicIntervalNumber.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Algebra
import Math

/// Interface for `DiatonicIntervalNumber`-like values.
public protocol DiatonicIntervalNumber {

    // MARK: - Type Methods

    /// - Returns: The distance from the given `interval` to the ideal interval for the given amount of `steps`.
    static func distanceToIdealInterval(for steps: Int, to interval: Double) -> Double

    // MARK: - Computed Properties

    /// The amount of diatonic steps represented by this `IntervalOrdinal`.
    var steps: Int { get }

    // MARK: - Initializers

    /// Creates a `DiatonicIntervalNumber` with the given amount of `steps`.
    init?(steps: Int)
}

protocol WesternScaleMappingOrdinal: DiatonicIntervalNumber {
    var augDimThreshold: Double { get }
}
