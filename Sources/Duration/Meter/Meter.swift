//
//  Meter.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import Algebra
import DataStructures
import Math

/// Abstract structure of beats which are concretely represented in a measure.
///
/// To create a basic meter, it is a simple as:
///
///     let common = Meter(4,4)
///     let waltz = Meter(3,4)
///     let ferneyhough = Meter(3,12)
///
/// A fractional meter can be created like so:
///
///     let fractional = Meter(Fraction(3,5),16)
///
/// Any number of meters can be combined into an additive meter:
///
///     let blueRondo = Meter(2,8) + Meter(2,8) + Meter(2,8) + Meter(3,8)
///     let czernowinSQm5 = Meter(Meter(1,4),Meter(3,16))
///
/// Basic and fractional meters can also be combined:
///
///     let czernowinSQm7 = Meter(Meter(1,4),Meter(Fraction(2,3),4))
///
public struct Meter {

    let kind: Kind

    private init(kind: Kind) {
        self.kind = kind
    }

    private init(kinds: [Kind]) {
        self.init(kind: .additive(kinds))
    }
}

extension Meter {

    // MARK: - Initializers

    /// Creates a `Meter` with the given `beats` and `subdivision`.
    public init(_ beats: Int, _ subdivision: Int) {
        self = .init(kind: .single(beats, subdivision))
    }

    /// Creates a fractional meter, with the given `fraction` and `subdivision`.
    public init(_ fraction: Fraction, _ subdivision: Int) {
        self = .init(kind: .fractional(fraction, subdivision))
    }

    /// Creates a `Meter` by aggregating all of the given `meters`.
    public init <C> (_ meters: C) where C: Swift.Collection, C.Element == Meter {
        self = meters.sum
    }
}

extension Meter {

    // MARK: - Computed Properties

    /// - Returns: The offsets of each beat contained herein.
    public var beatOffsets: [Fraction] {
        return kind.beatOffsets
    }
}

extension Meter: Additive {

    // MARK: - Additive

    /// - Returns: A `Meter` with no duration.
    public static var zero: Meter {
        return .init(0,1)
    }

    /// - Returns: An additive meter composed of the two given meters.
    public static func + (_ lhs: Meter, _ rhs: Meter) -> Meter {
        return Meter(kind: lhs.kind + rhs.kind)
    }
}

extension Meter: Multiplicative {

    // MARK: - Multiplicative

    /// - Returns: A `Meter` with `beats` and `subdivision` values of `1`.
    public static var one: Meter {
        return .init(1,1)
    }

    /// - Returns: The multiplicative product of the given meters.
    public static func * (lhs: Meter, _ rhs: Meter) -> Meter {
        return Meter(kind: lhs.kind * rhs.kind)
    }
}

extension Meter: Rational {

    // MARK: - Rational

    /// - Returns: The `numerator` for `Rational` arithmetic.
    public var numerator: Int {
        return kind.numerator
    }

    /// - Returns: The `denominator` for `Rational` arithmetic.
    public var denominator: Int {
        return kind.denominator
    }
}

extension Meter: Intervallic {

    // MARK: - Intervallic

    /// A `Meter` is measured by a `Fraction`.
    public typealias Metric = Fraction

    /// - Returns: The fractional length of a `Meter`.
    public var length: Fraction {
        return kind.length
    }
}

extension Meter: IntervallicFragmentable {

    // MARK: - IntervallicFragmentable

    /// - Returns: A `Meter.Fragment` in the given `range`.
    public func fragment(in range: Range<Fraction>) -> Meter.Fragment {
        return Meter.Fragment(self, in: range)
    }
}

extension Meter: ExpressibleByIntegerLiteral {

    // MARK: - ExpressibleByIntegerLiteral

    /// Creates a `Meter` with the given amount of `beats` over a subdivision of `1`.
    public init(integerLiteral beats: Int) {
        self.init(beats,1)
    }
}
