//
//  Meter.Kind.swift
//  Duration
//
//  Created by James Bean on 8/27/18.
//

import Algebra
import DataStructures
import Math

extension Meter {

    enum Kind {
        case single(_ beats: Int, _ subdivision: Int)
        case fractional(_ fraction: Fraction, _ subdivision: Int)
        indirect case additive([Kind])
    }
}

extension Meter.Kind {
    var beatOffsets: [Fraction] {
        switch self {
        case .single(let beats, let subdivision):
            return (0..<beats).map { beat in Fraction(beat,subdivision) }
        case .fractional(let fraction, let subdivision):
            let offset = fraction / Fraction(subdivision,1)
            return (0..<fraction.numerator).map { beat in Fraction(beat,1) * offset }
        case .additive(let meters):
            return meters.reduce(into: []) { accum, cur in
                accum.append(contentsOf: cur.beatOffsets.map { $0 + accum.sum })
            }
        }
    }
}

extension Meter.Kind: Additive {

    // MARK: - Additive

    /// The additive zero value.
    static var zero: Meter.Kind {
        return .single(0,1)
    }

    /// The additive operation.
    static func + (_ lhs: Meter.Kind, _ rhs: Meter.Kind) -> Meter.Kind {
        switch (lhs,rhs) {
        case let (.single(lhsBeats, lhsSubdivision), .single(rhsBeats, rhsSubdivision)):
            let fraction = Fraction(lhsBeats, lhsSubdivision) + Fraction(rhsBeats, rhsSubdivision)
            return .single(fraction.numerator, fraction.denominator)
        default:
            return .additive([lhs,rhs])
        }
    }
}

extension Meter.Kind: Multiplicative {

    // MARK: - Multiplicative

    /// The multiplicative one value.
    static var one: Meter.Kind {
        return .single(1,1)
    }

    /// The multiplicative operation.
    static func * (_ lhs: Meter.Kind, _ rhs: Meter.Kind) -> Meter.Kind {
        switch (lhs,rhs) {
        case (.additive(let meters),.single), (.additive(let meters),.fractional):
            let metersProduct = meters.product
            let metersFraction = Fraction(metersProduct.numerator,metersProduct.denominator)
            let product = Fraction(rhs.numerator,rhs.denominator) * metersFraction
            return .single(product.numerator, product.denominator)
        case (.single,.additive(let meters)), (.fractional,.additive(let meters)):
            let metersProduct = meters.product
            let metersFraction = Fraction(metersProduct.numerator,metersProduct.denominator)
            let product = Fraction(lhs.numerator,lhs.denominator) * metersFraction
            return .single(product.numerator, product.denominator)
        default:
            let product = Fraction(lhs.numerator,lhs.denominator) * Fraction(rhs.numerator,rhs.denominator)
            return .single(product.numerator, product.denominator)
        }
    }
}

extension Meter.Kind: Rational {

    // MARK: - Rational

    /// Create a `Meter.Kind` with the given `beats` and `subdivision`.
    init(_ beats: Int, _ subdivision: Int) {
        self = .single(beats, subdivision)
    }

    /// - Returns: The `numerator` for `Rational` arithmetic.
    var numerator: Int {
        switch self {
        case .single(let beats, _):
            return beats
        case .fractional(let fraction, let subdivision):
            return (Fraction(1,subdivision) * fraction).numerator
        case .additive(let meters):
            return meters.map(Fraction.init).sum.numerator
        }
    }

    /// - Returns: The `denominator` for `Rational` arithmetic.
    var denominator: Int {
        switch self {
        case .single(_, let subdivision):
            return subdivision
        case .fractional(let fraction, let subdivision):
            return (Fraction(1,subdivision) * fraction).denominator
        case .additive(let meters):
            return meters.map(Fraction.init).sum.denominator
        }
    }
}

extension Meter.Kind: Intervallic {

    // MARK: - Intervallic

    /// - Returns: The fractional length of this `Meter.Kind`.
    var length: Fraction {
        return Fraction(numerator,denominator)
    }
}

extension Meter.Kind: ExpressibleByIntegerLiteral {

    // MARK: - ExpressibleByIntegerLiteral

    /// Creates a `Meter.Kind` with the given `beats` and `subdivision` of `1`.
    init(integerLiteral beats: Int) {
        self = .single(beats,1)
    }
}
