//
//  MetricalDuration.swift
//  Rhythm
//
//  Created by James Bean on 1/2/17.
//
//

import Math

/// `MetricalDuration`.
public struct MetricalDuration: Rational {

    // MARK: - Type Properties

    /// A `MetricalDuration` with zero length.
    public static let zero = MetricalDuration(0,1)

    // MARK: - Instance Properties

    /// Numerator.
    public let numerator: Beats

    /// Denominator.
    public let denominator: Subdivision

    // MARK: - Initializers

    /// Create a `MetricalDuration` with a `numerator` and `denominator`.
    public init(_ numerator: Beats, _ denominator: Subdivision) {

        assert(
            denominator.isPowerOfTwo,
            "Cannot create MetricalDuration with non-power-of-two denominator: " + "\(denominator)"
        )

        self.numerator = numerator
        self.denominator = denominator
    }
}

extension MetricalDuration: ExpressibleByIntegerLiteral {

    // MARK: - ExpressibleByIntegerLiteral

    /// Creates a `MetricalDuration` with the given amount of `beats` at the quarter-note
    /// level.
    public init(integerLiteral beats: Int) {
        self.init(beats, 4)
    }
}

infix operator /> : BitwiseShiftPrecedence

/// Create a `MetricalDuration` with the `/>` operator between two `Int` values.
public func /> (numerator: Beats, denominator: Subdivision) -> MetricalDuration {
    return MetricalDuration(numerator, denominator)
}
