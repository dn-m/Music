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

    /// - returns: Array of `MetricalDuration` offsets of each beat in a meter.
    public var beatOffsets: [MetricalDuration] {
        return (0..<numerator).map { beat in MetricalDuration(beat, denominator) }
    }

    /// Numerator.
    public let numerator: Beats

    /// Denominator.
    public let denominator: Subdivision

    // MARK: Initializers

    /// Creates a `Meter` with the given `numerator` and `denominator`.
    public init(_ numerator: Beats, _ denominator: Subdivision) {
        assert(denominator.isPowerOfTwo, "Cannot create Meter with a non power-of-two denominator")
        self.numerator = numerator
        self.denominator = denominator
    }

    // MARK: - Instance Methods

    /// - returns: Offsets of each beat of a `Meter` at the given `Tempo`.
    ///
    /// - TODO: Change [Double] -> [Seconds]
    ///
    public func offsets(tempo: Tempo) -> [Double] {
        let durationForBeat = tempo.duration(forBeatAt: denominator)
        return (0..<numerator).map { Double($0) * durationForBeat }
    }

    /// - returns: Duration in seconds of measure at the given `tempo`.
    public func duration(at tempo: Tempo) -> Double {
        return Double(numerator) * tempo.duration(forBeatAt: denominator)
    }
}

extension Meter: MetricalDurationSpanning {

    /// - returns: The `MetricalDuration` of the `Meter`.
    public var length: Fraction {
        return Fraction(self)
    }
}

extension Meter: Fragmentable {

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

    public struct Collection: SpanningContainer {

        public typealias Metric = Fraction

        public let base: SortedDictionary<Fraction,Meter.Fragment>

        public init(_ base: SortedDictionary<Fraction, Meter.Fragment>) {
            self.base = base
        }

        public init <S> (_ base: S) where S: Sequence, S.Iterator.Element == Meter.Fragment {
            self = Builder().add(base).build()
        }

        public init <S> (_ base: S) where S: Sequence, S.Iterator.Element == Meter {
            self.init(base.map(Meter.Fragment.init))
        }
    }
}

extension Meter.Collection: Equatable {

    public static func == (lhs: Meter.Collection, rhs: Meter.Collection) -> Bool {
        return lhs.base == rhs.base
    }
}

extension Meter.Collection {

    public final class Builder: MetricalDurationSpanningContainerBuilder {

        public typealias Product = Meter.Collection

        public var intermediate: SortedDictionary<Fraction,Meter.Fragment>
        public var offset: Fraction

        public init() {
            self.intermediate = [:]
            self.offset = .zero
        }
    }
}
