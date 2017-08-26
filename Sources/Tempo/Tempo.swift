//
//  Tempo.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import Rhythm
import MetricalDuration

/// Model of a `Tempo`.
public struct Tempo {

    // MARK: - Associated Types
    
    public typealias BeatsPerMinute = Double

    // MARK: - Instance Properties

    /// Duration in seconds of a given beat.
    public var durationOfBeat: Double {
        return 60 / beatsPerMinute
    }

    /// Double value of `Tempo`.
    public var doubleValue: Double {
        return beatsPerMinute / Double(subdivision)
    }

    /// Value of `Tempo`.
    public let beatsPerMinute: BeatsPerMinute

    /// Subdivision of `Tempo`.
    ///
    /// - 1: whole note
    /// - 2: half note
    /// - 4: quarter note
    /// - 8: eighth note
    /// - 16: sixteenth note
    /// - ...
    public let subdivision: Subdivision

    // MARK: - Initializers

    /// Creates a `Tempo` with the given `value` for the given `subdivision`.
    public init(_ beatsPerMinute: BeatsPerMinute, subdivision: Subdivision = 4) {
        assert(subdivision != 0, "Cannot create a tempo with a subdivision of 0")
        self.beatsPerMinute = beatsPerMinute
        self.subdivision = subdivision
    }

    public func respelling(subdivision newSubdivision: Subdivision) -> Tempo {
        assert(newSubdivision.isPowerOfTwo, "Non-power-of-two subdivisions not yet supported")
        guard newSubdivision != subdivision else { return self }
        let quotient = Double(newSubdivision) / Double(subdivision)
        let newBeatsPerMinute = beatsPerMinute * quotient
        return Tempo(newBeatsPerMinute, subdivision: newSubdivision)
    }

    /// - returns: Duration for a beat at the given `subdivision`.
    public func duration(forBeatAt subdivision: Subdivision) -> Double {
        assert(subdivision.isPowerOfTwo, "Subdivision must be a power-of-two")
        let quotient = Double(subdivision) / Double(self.subdivision)
        return durationOfBeat / quotient
    }
}

extension Tempo: Equatable {

    // MARK: - Equatable

    /// - returns: `true` if `Tempo` values are equivalent. Otherwise, `false`.
    public static func == (lhs: Tempo, rhs: Tempo) -> Bool {
        return lhs.doubleValue == rhs.doubleValue
    }
}

// FIXME: Move to own file (Tempo.Interpolation) when Swift compiler build-order bug resolved.
import Darwin
import Math

extension Tempo {

    /// Interpolation between two `Tempo` values.
    public struct Interpolation: MetricalDurationSpanning {

        // MARK: Instance Properties

        /// Concrete duration of `Interpolation`, in seconds.
        public var duration: Double/*Seconds*/ {
            return secondsOffset(for: length)
        }

        /// Start tempo.
        public let start: Tempo

        /// End tempo.
        public let end: Tempo

        /// Metrical duration.
        public let length: Fraction

        /// Easing of `Interpolation`.
        public let easing: Easing

        // MARK: - Initializers

        /// Creates an `Interpolation` with the given `start` and `end` `Tempo` values, lasting
        /// for the given metrical `duration`.
        public init(
            start: Tempo = Tempo(60),
            end: Tempo = Tempo(60),
            length: Fraction = Fraction(1,4),
            easing: Easing = .linear
        )
        {
            self.start = start
            self.end = end
            self.length = length
            self.easing = easing
        }

        /// Creates a static `Interpolation` with the given `tempo`, lasting for the given
        /// metrical `duration`.
        public init(tempo: Tempo, length: Fraction = Fraction(1,4)) {
            self.start = tempo
            self.end = tempo
            self.length = length
            self.easing = .linear
        }

        // MARK: - Instance Properties

        /// - returns: The effective tempo at the given `metricalOffset`.
        ///
        /// - TODO: Must incorporate non-linear interpolations if/when they are implemented!
        ///
        public func tempo (at metricalOffset: Fraction) -> Tempo {
            let (start, end, _, _) = normalizedValues(offset: metricalOffset)
            let x = (metricalOffset / length).doubleValue
            let ratio = end.beatsPerMinute / start.beatsPerMinute
            let xEased = easing.evaluate(at: x)
            let scaledBpm = start.beatsPerMinute * pow(ratio, xEased)
            return Tempo(scaledBpm, subdivision: start.subdivision)
        }

        /// - returns: The concrete offset in seconds of the given symbolic `MetricalDuration`
        /// `offset`. If the easing type is .linear, this method gives an exact answer;
        /// otherwise, it uses an approximation method with complexity linear in the
        /// magnitude of `metricalOffset`.
        ///
        /// - TODO: Change Double -> Seconds
        ///
        public func secondsOffset(for metricalOffset: Fraction) -> Double/*Seconds*/ {

            let resolution = 1024

            // First, guard against the easy cases
            // 1. Zero offset => zero output
            guard metricalOffset != .zero else {
                return 0
            }

            // 2. Start tempo == end tempo
            let (start, end, duration, offset) = normalizedValues(offset: metricalOffset)
            guard start != end else {
                return Double(offset.numerator) * start.durationOfBeat
            }

            switch easing {

            case .linear:
                // 3. If Easing is linear, there is a simple and exact integral we can use
                let a = start.durationOfBeat
                let b = end.durationOfBeat
                let x = (metricalOffset / length).doubleValue
                let integralValue = (pow(b/a, x)-1) * a / log(b/a)
                return integralValue * Double(duration.numerator)

            default:

                // Base case: rough approximation
                let segmentsCount = Int(floor((offset / Fraction(1, resolution)).doubleValue))

                let accum: Double = (0..<segmentsCount).reduce(.zero) { accum, cur in
                    let tempo = self.tempo(at: Fraction(cur, resolution))
                    let duration = tempo.duration(forBeatAt: resolution)
                    return accum + duration
                }

                // If approximate resolution fits nicely, we are done
                if lcm(resolution, offset.denominator) == resolution {
                    return accum
                }

                // Add on bit that doesn't fit right
                let remainingOffset = Fraction(segmentsCount, resolution)
                let remainingTempo = tempo(at: remainingOffset)
                let remainingMetricalDuration = offset - remainingOffset
                let beats = remainingMetricalDuration.numerator
                let subdivision = remainingMetricalDuration.denominator
                let remaining = remainingTempo.duration(forBeatAt: subdivision) * Double(beats)
                return accum + remaining
            }
        }

        private func normalizedValues(offset: Fraction)
            -> (start: Tempo, end: Tempo, duration: Fraction, offset: Fraction)
        {

            let lcm = [
                start.subdivision,
                end.subdivision,
                length.denominator,
                offset.denominator
            ].lcm

            return (
                start: start.respelling(subdivision: lcm),
                end: end.respelling(subdivision: lcm),
                duration: length.scaling(denominator: lcm),
                offset: offset.scaling(denominator: lcm)
            )
        }
    }
}

extension Tempo.Interpolation: Fragmentable {

    public subscript(range: Range<Fraction>) -> Fragment {
        assert(range.lowerBound >= .zero)
        assert(range.upperBound <= length)
        return Fragment(self, in: range)
    }
}

// FIXME: Move to own file (Tempo.Interpolation.Fragment)
extension Tempo.Interpolation {

    public struct Fragment: MetricalDurationSpanningFragment {

        public typealias Metric = Fraction

        public var duration: Double {
            let start = base.secondsOffset(for: range.lowerBound)
            let end = base.secondsOffset(for: range.upperBound)
            return end - start
        }

        public let base: Tempo.Interpolation
        public let range: Range<Fraction>

        public init(_ interpolation: Tempo.Interpolation, in range: Range<Fraction>) {
            self.base = interpolation
            self.range = range
        }

        /// - Returns: `Interpolation.Fragment` in the given `range`.
        public subscript(range: Range<Fraction>) -> Tempo.Interpolation.Fragment {
            assert(range.lowerBound >= self.range.lowerBound)
            assert(range.upperBound <= self.range.upperBound)
            return Tempo.Interpolation.Fragment(base, in: range)
        }

        public func secondsOffset(for metricalOffset: Fraction) -> Double {
            return base.secondsOffset(for: metricalOffset)
        }
    }
}

extension Tempo.Interpolation.Fragment {

    public init(_ interpolation: Tempo.Interpolation) {
        self.base = interpolation
        self.range = .zero ..< interpolation.length
    }
}

// FIXME: Move to own file (Tempo.Interpolation.Easing)
import DataStructures

extension Tempo.Interpolation {

    /// Easing of `Interpolation`.
    public enum Easing {

        /// Linear interpolation.
        case linear

        /// `x^e` interpolation in, with the given `exponent`.
        case powerIn(exponent: Double)

        /// `x^e` interpolation in-out, with the given `exponent`.
        case powerInOut(exponent: Double)

        /// `b^x` interpolation in, with the given `base`.
        case exponentialIn(base: Double)

        /// Ease in / ease out (half sine wave)
        case sineInOut

        /// - returns: The easing function evaluated at `x`.
        func evaluate(at x: Double) -> Double {

            assert((0...1).contains(x), "\(#function): input must lie in [0, 1]")

            switch self {

            case .linear:
                return x

            case .powerIn(let e):
                assert(e > 0, "\(#function): powerIn exponent must be positive")
                return pow(x, e)

            case .powerInOut(let e):
                assert(e >= 1, "\(#function): powerInOut exponent must be >= 1")
                if x <= 0.5 {
                    return pow(x, e) * pow(2, e - 1)
                } else {
                    return pow(1 - x, e) * -pow(2, e - 1) + 1
                }

            case .exponentialIn(let b):
                assert(b > 0, "\(#function): exponentialIn base must be > 0")
                assert(b != 1, "\(#function): exponentialIn base must not be 1")
                return (pow(b, x)-1) / (b-1)

            case .sineInOut:
                return 0.5 * (1 - cos(x * .pi))
            }
        }

        /// - returns: The integral of the easing function from 0 to `x`.
        func integrate(at x: Double) -> Double {

            assert((0...1).contains(x), "\(#function): input must lie in [0, 1]")

            switch self {

            case .linear:
                return pow(x, 2) / 2

            case .powerIn(let e):
                assert(e > 0, "\(#function): exponent must be positive")
                return pow(x, e + 1) / (e + 1)

            case .powerInOut(let e):
                assert(e > 0, "\(#function): Exponent must be at least 1")
                if x <= 0.5 {
                    return pow(2, e-1) / (e+1) * pow(x, (e+1))
                } else {
                    return pow(2, e-1) * pow(1-x, 1+e) / (1+e) + x - 0.5
                }

            case .exponentialIn(let b):
                assert(b > 0, "\(#function): Base must be positive")
                assert(b != 1, "\(#function): Base must not be 1")
                return ((pow(b, x)/log(b)) - x) / (b-1)

            case .sineInOut:
                return (x - sin(.pi * x) / .pi) / 2
            }
        }
    }
}

// FIXME: Move to own file (Tempo.Interpolation.Collection)
public extension Tempo.Interpolation {

    public struct Collection: SpanningContainer {

        public typealias Metric = Spanner.Metric
        public typealias Spanner = Tempo.Interpolation.Fragment

        public let base: SortedDictionary<Spanner.Metric,Spanner>

        public init(_ base: SortedDictionary<Spanner.Metric,Spanner>) {
            self.base = base
        }

        public init <S> (_ base: S) where S: Sequence, S.Iterator.Element == Spanner {
            self = Builder().add(base).build()
        }

        public init <S> (_ elements: S) where S: Sequence, S.Element == Tempo.Interpolation {
            self.init(elements.map { Tempo.Interpolation.Fragment($0) })
        }

        /// - FIXME: Use `Seconds` instead of `Double`
        public func secondsOffset(for metricalOffset: Fraction) -> Double {
            assert(contains(metricalOffset))
            let index = indexOfElement(containing: metricalOffset)!
            let (globalOffset, interpolation) = base[index]
            let internalOffset = metricalOffset - globalOffset
            let localSeconds = interpolation.secondsOffset(for: internalOffset)
            return secondsOffset(at: index) + localSeconds
        }

        public func secondsOffset(at index: Int) -> Double {
            assert(base.indices.contains(index))
            return (0..<index)
                .lazy
                .map { self.base[$0] }
                .map { _, interp in interp.duration }
                .sum
        }
    }
}

// FIXME: Move to own file (Tempo.Interpolation.Collection.Builder)

extension Tempo.Interpolation.Collection {

    public final class Builder: MetricalDurationSpanningContainerBuilder {

        public typealias Product = Tempo.Interpolation.Collection

        public var intermediate: SortedDictionary<Fraction,Tempo.Interpolation.Fragment>
        public var offset: Fraction

        private var last: (Fraction, Tempo, Bool)?

        public init() {
            self.intermediate = [:]
            self.offset = .zero
        }

        @discardableResult public func add(_ interpolation: Tempo.Interpolation.Fragment)
            -> Builder
        {
            self.intermediate.insert(interpolation, key: offset)
            last = (offset, interpolation.base.end, true)
            offset += interpolation.range.length
            return self
        }

        @discardableResult public func add(
            _ tempo: Tempo,
            at offset: Fraction,
            interpolating: Bool = false
        ) -> Builder
        {
            if let (startOffset, startTempo, startInterpolating) = last {
                let interpolation = Tempo.Interpolation(
                    start: startTempo,
                    end: startInterpolating ? tempo : startTempo,
                    length: offset - startOffset,
                    easing: .linear
                )
                add(.init(interpolation))
            }
            last = (offset, tempo, interpolating)
            return self
        }
    }
}

