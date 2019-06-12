//
//  Tempo.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import DataStructures

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
}

extension Tempo {

    // MARK: - Initializers

    /// Creates a `Tempo` with the given `value` for the given `subdivision`.
    public init(_ beatsPerMinute: BeatsPerMinute, subdivision: Subdivision = 4) {
        assert(subdivision != 0, "Cannot create a tempo with a subdivision of 0")
        self.beatsPerMinute = beatsPerMinute
        self.subdivision = subdivision
    }
}

extension Tempo {

    // MARK: - Instance Methods

    /// - Returns: A `Tempo` with the numerator and subdivision adjusted to match the given
    /// `subdivision`.
    public func respelling(subdivision newSubdivision: Subdivision) -> Tempo {
        precondition(newSubdivision.isPowerOfTwo, "Non-power-of-two subdivisions not yet supported")
        guard newSubdivision != subdivision else { return self }
        let quotient = Double(newSubdivision) / Double(subdivision)
        let newBeatsPerMinute = beatsPerMinute * quotient
        return Tempo(newBeatsPerMinute, subdivision: newSubdivision)
    }

    /// - Returns: Duration in seconds for a beat at the given `subdivision`.
    public func duration(forBeatAt subdivision: Subdivision) -> Double {
        precondition(subdivision.isPowerOfTwo, "Subdivision must be a power-of-two")
        let quotient = Double(subdivision) / Double(self.subdivision)
        return durationOfBeat / quotient
    }
}

extension Tempo: Equatable { }

extension Tempo: ExpressibleByIntegerLiteral {

    // MARK: - ExpressibleByIntegerLiterl

    /// Create a `Tempo` with a `beatsPerMinute` of the given `value`, at the quarter-note level.
    public init(integerLiteral value: Int) {
        self.init(Double(value))
    }
}

extension Tempo: ExpressibleByFloatLiteral {

    // MARK: - ExpressibleByIntegerLiterl

    /// Create a `Tempo` with a `beatsPerMinute` of the given `value`, at the quarter-note level.
    public init(floatLiteral value: Double) {
        self.init(value)
    }
}

// FIXME: Move to own file (Tempo.Interpolation) when Swift compiler build-order bug resolved.
import Math

extension Tempo {

    /// Interpolation between two `Tempo` values.
    public struct Interpolation: Intervallic {

        public typealias Metric = Fraction

        // MARK: - Cases

        /// Start tempo.
        public let start: Tempo

        /// End tempo.
        public let end: Tempo

        /// Metrical duration.
        public let length: Fraction

        /// Easing of `Interpolation`.
        public let easing: Easing

        // MARK: Instance Properties

        /// Concrete duration of `Interpolation`, in seconds.
        public var duration: Double/*Seconds*/ {
            return secondsOffset(for: length)
        }

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

        /// - Returns: The effective tempo at the given metrical `offset`.
        public func tempo (at offset: Fraction) -> Tempo {
            let (start, end, _, _) = normalizedValues(offset: offset)
            let x = (offset / length).doubleValue
            let ratio = end.beatsPerMinute / start.beatsPerMinute
            let xEased = easing.evaluate(at: x)
            let scaledBpm = start.beatsPerMinute * pow(ratio, xEased)
            return Tempo(scaledBpm, subdivision: start.subdivision)
        }

        /// - Returns: The concrete offset in seconds of the given symbolic `Duration`
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
                let remainingDuration = offset - remainingOffset
                let beats = remainingDuration.numerator
                let subdivision = remainingDuration.denominator
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

extension Tempo.Interpolation: Equatable { }

// FIXME: Move to own file (Tempo.Interpolation.Fragment)
extension Tempo.Interpolation {

    /// A fragment of a `Tempo.Interpolation`.
    public struct Fragment {

        // MARK: - Associated Types

        /// The measurable unit of a `Tempo.Interpolation` is a `Fraction`.
        public typealias Metric = Fraction

        // MARK: - Instance Properties

        /// The duration in seconds of the `Tempo.Interpolation`.
        public var duration: Double {
            let start = base.secondsOffset(for: range.lowerBound)
            let end = base.secondsOffset(for: range.upperBound)
            return end - start
        }

        /// The original `Tempo.Interpolation`.
        public let base: Tempo.Interpolation

        /// The range within the original `Tempo.Interpolation` of this `Fragment`.
        public let range: Range<Fraction>

        // MARK: - Subscripts

        /// - Returns: `Interpolation.Fragment` in the given `range`.
        public subscript(range: Range<Fraction>) -> Tempo.Interpolation.Fragment {
            assert(range.lowerBound >= self.range.lowerBound)
            assert(range.upperBound <= self.range.upperBound)
            return Tempo.Interpolation.Fragment(base, in: range)
        }
    }
}

extension Tempo.Interpolation: IntervallicFragmentable {

    // MARK: - Fragmentable

    /// - Returns: a `Tempo.Interpolation.Fragment` in the given `range`.
    public func fragment(in range: Range<Fraction>) -> Fragment {
        assert(range.lowerBound >= .zero)
        assert(range.upperBound <= length)
        return Fragment(self, in: range)
    }
}

extension Tempo.Interpolation.Fragment: Intervallic {

    // MARK: - Intervallic

    /// - Returns: The length of this `Tempo.Interpolation.Fragment` value.
    public var length: Fraction {
        return range.length
    }
}

extension Tempo.Interpolation.Fragment: Totalizable {

    // MARK: - Totalizable

    /// Creates a `Tempo.Interpolation.Fragment` which is equivalent to the given `whole`
    /// `Tempo.Interpolation`.
    public init(whole: Tempo.Interpolation) {
        self.init(whole)
    }
}

extension Tempo.Interpolation.Fragment: IntervallicFragmentable {

    // MARK: - IntervallicFragmentable

    /// - Returns: A fragment in the given `range`.
    public func fragment(in range: Range<Fraction>) -> Tempo.Interpolation.Fragment {
        return .init(base, in: range.clamped(to: self.range))
    }
}

extension Tempo.Interpolation.Fragment {

    // MARK: - Initializers

    /// Create a `Tempo.Interpolation.Fragment` with the given `interpolation` in the given
    /// `range`.
    public init(_ interpolation: Tempo.Interpolation, in range: Range<Fraction>) {
        self.base = interpolation
        self.range = range
    }

    /// Create a `Tempo.Interpolation.Fragment` which fills the entire length of the given
    /// `interpolation`.
    public init(_ interpolation: Tempo.Interpolation) {
        self.base = interpolation
        self.range = .zero ..< interpolation.length
    }
}

extension Tempo.Interpolation.Fragment {

    // MARK: - Instance Methods

    /// - Returns: The offset in seconds of the given metrical `offset`.
    public func secondsOffset(for offset: Fraction) -> Double {
        return base.secondsOffset(for: offset)
    }
}

extension Tempo.Interpolation.Fragment: Equatable { }

// FIXME: Move to own file (Tempo.Interpolation.Easing)
import DataStructures

extension Tempo.Interpolation {

    /// Easing of `Interpolation`.
    //
    // TODO: Generalize this beyond tempi.
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

extension Tempo.Interpolation.Easing: Equatable { }

// FIXME: Move to own file (Tempo.Interpolation.Collection)
public extension Tempo.Interpolation {

    /// An ordered, contiguous collection of `Tempo.Interpolation.Fragments` indexed by their
    /// fractional offset.
    typealias Collection = ContiguousSegmentCollection<Tempo.Interpolation>
}

/// A class which encapsulates the stateful incremental building process of
/// a `Tempo.Interpolation.Collection`.
public final class TempoInterpolationCollectionBuilder {

    // MARK: - Associated Types

    /// The end result of the building process (`Tempo.Interpolation.Collection`).
    public typealias Product = Tempo.Interpolation.Collection

    // MARK: - Instance Properties

    private var last: (offset: Fraction, tempo: Tempo, easing: Tempo.Interpolation.Easing?)?

    /// The intermediate storage of `Tempo.Interpolation.Fragment` values indexed by their
    /// `Fraction` offsets.
    public var intermediate: OrderedDictionary<Fraction,Tempo.Interpolation>

    // MARK: - Initializers

    /// Create an empty `Tempo.Interpolation.Collection.Builder` ready to construct a nice
    /// little `Tempo.Interpolation.Collection` for you.
    public init() {
        self.intermediate = [:]
    }

    // MARK: - Instance Methods

    /// Add the given `interpolation` to the accumulating storage of
    /// `Tempo.Interpolation.Fragment` values.
    ///
    /// - Returns: Self
    @discardableResult public func add(_ interpolation: Tempo.Interpolation)
        -> TempoInterpolationCollectionBuilder
    {
        let offset = last?.offset ?? .zero
        intermediate.append(interpolation, key: offset)
        last = (offset, interpolation.end, nil)
        return self
    }

    /// Add the given `tempo` at the given metrical `offset`, along with the information
    /// whether the given `tempo` interpolates into the next.
    @discardableResult public func add(
        _ tempo: Tempo,
        at offset: Fraction,
        easing: Tempo.Interpolation.Easing? = nil
    ) -> TempoInterpolationCollectionBuilder
    {
        if let (startOffset, startTempo, easing) = last {
            let interpolation = Tempo.Interpolation(
                start: startTempo,
                end: easing != nil ? tempo : startTempo,
                length: offset - startOffset,
                easing: easing ?? .linear
            )
            add(interpolation)
        }
        last = (offset, tempo, easing)
        return self
    }

    /// - Returns: The completed `Tempo.Interpolation.Collection`.
    public func build() -> Tempo.Interpolation.Collection {
        return .init(SortedDictionary(presorted: intermediate))
    }
}

extension ContiguousSegmentCollection where Segment == Tempo.Interpolation {

    // MARK: - Instance Methods

    /// - Returns: The offset in seconds of the given metrical `offset`.
    ///
    // - FIXME: Use `Seconds` instead of `Double`
    public func secondsOffset(for offset: Fraction) -> Double {
        assert(contains(offset))
        let index = indexOfSegment(containing: offset)!
        let (globalOffset, interpolation) = base[index]
        let internalOffset = offset - globalOffset
        let localSeconds = interpolation.secondsOffset(for: internalOffset)
        return secondsOffset(at: index) + localSeconds
    }

    /// - Returns: The offset in seconds of the `Tempo.Interpolation.Fragment` starting at the
    /// given `index`.
    public func secondsOffset(at index: Int) -> Double {
        assert(base.indices.contains(index))
        return (0..<index)
            .lazy
            .map { self.base[$0] }
            .map { _, interp in interp.duration }
            .sum
    }
}
