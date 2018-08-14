//
//  Meter.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import Math

/// Model of a `Meter`.
public struct Meter: Rational {

    // MARK: - Instance Properties

    /// - Returns: Array of `Duration` offsets of each beat in a meter.
    public var beatOffsets: [Duration] {
        return (0..<numerator).map { beat in Duration(beat, denominator) }
    }

    /// Numerator.
    public let numerator: Beats

    /// Denominator.
    public let denominator: Subdivision

    // MARK: Initializers

    /// Creates a `Meter` with the given `numerator` and `denominator`.
    public init(_ numerator: Beats, _ denominator: Subdivision) {
        assert(denominator.isPowerOfTwoWithAnyCoefficient)
        self.numerator = numerator
        self.denominator = denominator
    }
}

extension FixedWidthInteger {
    var isPowerOfTwoWithAnyCoefficient: Bool {
        guard !isPowerOfTwo else { return true }
        return (1...self).lazy
            .filter { $0.isOdd }
            .flatMap { PowerSequence(coefficient: $0, max: self, doOvershoot: true) }
            .contains(self)
    }
}

extension Meter: DurationSpanning {

    // MARK: - DurationSpanning

    /// - Returns: The `Duration` of the `Meter`.
    public var length: Fraction {
        return Fraction(self)
    }
}

extension Meter: Fragmentable {

    // MARK: - Fragmentable

    /// - Returns: `Meter.Fragment`
    public subscript(range: Range<Fraction>) -> Fragment {
        return Fragment(self, in: range)
    }
}

extension Meter: ExpressibleByIntegerLiteral {

    // MARK: - ExpressibleByIntegerLiteral
    
    /// Creates a `Meter` with the given amount of `beats` at the quarter-note level.
    public init(integerLiteral beats: Int) {
        self.init(beats, 4)
    }
}

// FIXME: Move to own file when Swift build order bug is resolved
import DataStructures

extension Meter {

    /// A dictionary-like collections with `Meter.Fragment` values indexed by `Fraction` keys`.
    public struct Collection: SpanningContainer {

        // MARK: - Associated Types

        public typealias Metric = Fraction

        // MARK: - Instance Properties

        public let base: SortedDictionary<Fraction,Meter.Fragment>

        // MARK: - Initializers

        /// Create a `Meter.Collection` with the given `base`.
        public init(_ base: SortedDictionary<Fraction, Meter.Fragment>) {
            self.base = base
        }

        /// Create a `Meter.Collection` with the given `base`.
        public init <S> (_ base: S) where S: Sequence, S.Element == Meter.Fragment {
            self = Builder().add(base).build()
        }

        /// Create a `Meter.Collection` with the given `base`.
        public init <S> (_ base: S) where S: Sequence, S.Element == Meter {
            self.init(base.map(Meter.Fragment.init))
        }
    }
}

extension Meter.Collection: Equatable { }

extension Meter.Collection {

    /// Stateful building of a `Meter.Collection`.
    public final class Builder: DurationSpanningContainerBuilder {

        // MARK: - Associated Types

        /// The end product of this `Meter.Collection.Builder`.
        public typealias Product = Meter.Collection

        // MARK: - Instance Properties

        /// The value which will ultimately be the underlying storage of a `Meter.Collection`.
        public var intermediate: SortedDictionary<Fraction,Meter.Fragment>

        /// The accumulating offset of `Fraction` keys.
        public var offset: Fraction

        // MARK: - Initializers

        /// Create an empty `Meter.Collection.Builder` ready to help you build up a
        /// `Meter.Collection`.
        public init() {
            self.intermediate = [:]
            self.offset = .zero
        }
    }
}
