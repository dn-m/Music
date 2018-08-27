//
//  Duration.swift
//  Rhythm
//
//  Created by James Bean on 1/2/17.
//
//

import Math

/// `Duration`.
public struct Duration {

    // MARK: - Type Properties

    /// A `Duration` with zero length.
    public static let zero = Duration(0,1)

    // MARK: - Instance Properties

    /// Numerator.
    public let beats: Beats

    /// Denominator.
    public let subdivision: Subdivision

    // MARK: - Initializers

    /// Create a `Duration` with a `beats` and `subdivision`.
    public init(_ numerator: Beats, _ denominator: Subdivision) {

        assert(
            denominator.isPowerOfTwo,
            "Cannot create Duration with non-power-of-two subdivision: " + "\(denominator)"
        )

        self.beats = numerator
        self.subdivision = denominator
    }
}

extension Duration: Rational {

    // MARK: - Rational

    /// - Returns: The `beats` value for `Rational` arithmetic.
    public var numerator: Int {
        return beats
    }

    /// - Returns: The `subdivision` value for `Rational` arithmetic.
    public var denominator: Int {
        return subdivision
    }
}

extension Duration: ExpressibleByIntegerLiteral {

    // MARK: - ExpressibleByIntegerLiteral

    /// Creates a `Duration` with the given amount of `beats` at the quarter-note
    /// level.
    public init(integerLiteral beats: Int) {
        self.init(beats, 4)
    }
}

infix operator /> : BitwiseShiftPrecedence

/// Create a `Duration` with the `/>` operator between two `Int` values.
public func /> (numerator: Beats, denominator: Subdivision) -> Duration {
    return Duration(numerator, denominator)
}
