//
//  UnorderedDiatonicInterval.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Algebra
import Algorithms
import DataStructures
import Math

/// Descriptor for unordered intervals between two `Pitch.Class` values.
public struct UnorderedDiatonicInterval: DiatonicIntervalProtocol {

    // MARK: - Instance Properties

    /// Quality of an `UnorderedIntervalDescriptor`.
    ///
    /// - `diminished`
    /// - `minor`
    /// - `perfect`
    /// - `major`
    /// - `augmented`
    ///
    public let quality: Quality

    /// Ordinal of an `UnorderedIntervalDescriptor`.
    ///
    /// - `unison`
    /// - `second`
    /// - `third`
    /// - `fourth`
    ///
    public let ordinal: Number
}

extension UnorderedDiatonicInterval {

    // MARK: - Computed Properties

    /// - Returns: The amount of semitones in this `UnorderedIntervalDescriptor`.
    public var semitones: Double {
        switch quality {
        case let .extended(extended):
            switch extended.quality {
            case .augmented:
                return ordinal.idealInterval + quality.adjustment + (ordinal.augDimThreshold - 1)
            case .diminished:
                return ordinal.idealInterval + quality.adjustment - (ordinal.augDimThreshold - 1)
            }
        default:
            return ordinal.idealInterval + quality.adjustment
        }
    }

    /// - Returns: The amount of letter name steps in this `UnorderedIntervalDescriptor`.
    public var steps: Int { return ordinal.steps }
}

extension UnorderedDiatonicInterval {

    // MARK: - Nested Types

    /// The number of a `UnorderedDiatonicInterval`.
    public enum Number: DiatonicIntervalNumber {

        // MARK: - Cases

        /// Imperfect unordered interval ordinals (e.g., unison, fourth).
        case perfect(Perfect)

        /// Perfect unordered interval ordinals (e.g., second, third).
        case imperfect(Imperfect)

        public var inverse: UnorderedDiatonicInterval.Number {
            switch self {
            case .perfect(let ordinal):
                return .perfect(ordinal.inverse)
            case .imperfect(let ordinal):
                return .imperfect(ordinal.inverse)
            }
        }

        /// The amount of diatonic steps represented by this `UnorderedIntervalDescriptor.Ordinal`.
        public var steps: Int {
            switch self {
            case .perfect(let perfect):
                return perfect.rawValue
            case .imperfect(let imperfect):
                return imperfect.rawValue
            }
        }
    }
}

extension UnorderedDiatonicInterval.Number {

    // MARK: - Initializers

    /// Createss a `UnorderedDiatonicInterval` with the given amount of `steps`.
    public init?(steps: Int) {
        switch steps {
        case 0: self = .perfect(.unison)
        case 1: self = .imperfect(.second)
        case 2: self = .imperfect(.third)
        case 3: self = .perfect(.fourth)
        default: return nil
        }
    }

    /// Creates an `UnorderedDiatonicInterval` with the given `ordered` interval.
    ///
    /// In the case that the `ordered` interval is out of range (e.g., `.fifth`, `.sixth`,
    /// `.seventh`), the `.inverse` is converted into an unordered interval (e.g., a `.seventh`
    /// becomes a `.second`).
    ///
    public init(_ ordered: DiatonicInterval.Number) {
        switch ordered {
        case .perfect(let perfect):
            switch perfect {
            case .unison:
                self = .perfect(.unison)
            case .fourth:
                self = .perfect(.fourth)
            case .fifth:
                self.init(ordered.inverse)
            }
        case .imperfect(let imperfect):
            switch imperfect {
            case .second:
                self = .imperfect(.second)
            case .third:
                self = .imperfect(.third)
            case .sixth:
                self.init(ordered.inverse)
            case .seventh:
                self.init(ordered.inverse)
            }
        }
    }
}

extension UnorderedDiatonicInterval.Number {

    // MARK: - Nested Types

    /// Perfect ordinals.
    public enum Perfect: Int, InvertibleEnum {

        // MARK: - Cases

        /// Unison perfect unordered interval ordinal.
        case unison = 0

        /// Fourth perfect unordered interval ordinal.
        case fourth = 3
    }

    /// Imperfect ordinals.
    public enum Imperfect: Int, InvertibleEnum {

        // MARK: - Cases

        /// Second imperfect unordered interval ordinal.
        case second = 1

        /// Third imperfect unordered interval ordinal.
        case third = 2
    }
}

extension UnorderedDiatonicInterval {

    // MARK: - Type Properties

    /// Diminished unison.
    public static let d1 = UnorderedDiatonicInterval(.diminished, .unison)

    /// Unison.
    public static let unison = UnorderedDiatonicInterval(.perfect, .unison)

    /// Diminished second.
    public static let d2 = UnorderedDiatonicInterval(.diminished, .second)

    /// Augmented unison.
    public static let A1 = UnorderedDiatonicInterval(.augmented, .unison)

    /// Minor second.
    public static let m2 = UnorderedDiatonicInterval(.minor, .second)

    /// Major second.
    public static let M2 = UnorderedDiatonicInterval(.major, .second)

    /// Diminished third.
    public static let d3 = UnorderedDiatonicInterval(.diminished, .third)

    /// Augmented second.
    public static let A2 = UnorderedDiatonicInterval(.augmented, .second)

    /// Minor third.
    public static let m3 = UnorderedDiatonicInterval(.minor, .third)

    /// Major third.
    public static let M3 = UnorderedDiatonicInterval(.major, .third)

    /// Diminished fourth.
    public static let d4 = UnorderedDiatonicInterval(.diminished, .fourth)

    /// Augmented third.
    public static let A3 = UnorderedDiatonicInterval(.augmented, .third)

    /// Perfect fourth.
    public static let P4 = UnorderedDiatonicInterval(.perfect, .fourth)

    /// Augmented fourth.
    public static let A4 = UnorderedDiatonicInterval(.augmented, .fourth)
}

extension UnorderedDiatonicInterval.Number {

    // MARK: - Type Methods

    /// - Returns: The distance from the given `interval` to the ideal interval for the given amount
    /// of `steps`.
    public static func distanceToIdealInterval(for steps: Int, to interval: Double) -> Double {
        let ideal = idealSemitoneInterval(steps: steps)
        let difference = interval - ideal
        let normalized = mod(difference + 6, 12) - 6
        return steps == 0 ? abs(normalized) : normalized
    }
}

extension UnorderedDiatonicInterval {

    // MARK: - Initializers

    // MARK: Perfect Interval Descriptors

    /// Creates a perfect `UnorderedDiatonicInterval`.
    ///
    ///     let perfectUnison = UnorderedDiatonicInterval(.perfect, .unison)
    ///     let perfectFourth = UnorderedDiatonicInterval(.perfect, .fourth)
    ///
    public init(_ quality: Quality.Perfect, _ ordinal: Number.Perfect) {
        self.quality = .perfect(.perfect)
        self.ordinal = .perfect(ordinal)
    }

    // MARK: Imperfect Interval Descriptors

    /// Creates an imperfect `UnorderedDiatonicInterval`.
    ///
    ///     let majorSecond = UnorderedDiatonicInterval(.major, .second)
    ///     let minorThird = UnorderedDiatonicInterval(.minor, .third)
    ///
    public init(_ quality: Quality.Imperfect, _ ordinal: Number.Imperfect) {
        self.quality = .imperfect(quality)
        self.ordinal = .imperfect(ordinal)
    }

    // MARK: Augmented or Diminished Interval Descriptors

    /// Creates an augmented or diminished `UnorderedDiatonicInterval` with an imperfect number.
    ///
    ///     let doubleDiminishedSecond = UnorderedDiatonicInterval(.diminished, .second)
    ///     let tripleAugmentedThird = UnorderedDiatonicInterval(.augmented, .third)
    ///
    public init(_ quality: Quality.Extended.AugmentedOrDiminished, _ ordinal: Number.Imperfect) {
        self.quality = .extended(.init(.single, quality))
        self.ordinal = .imperfect(ordinal)
    }

    /// Creates an augmented or diminished `UnorderedDiatonicInterval` with a perfect number.
    ///
    ///     let doubleAugmentedUnison = UnorderedDiatonicInterval(.augmented, .unison)
    ///     let tripleDiminishedFourth = UnorderedDiatonicInterval(.diminished, .fourth)
    ///
    public init(_ quality: Quality.Extended.AugmentedOrDiminished, _ ordinal: Number.Perfect) {
        self.quality = .extended(.init(.single, quality))
        self.ordinal = .perfect(ordinal)
    }

    /// Creates an augmented or diminished `UnorderedDiatonicInterval` with an imperfect number.
    /// These intervals can be up to quintuple augmented or diminished.
    ///
    ///     let doubleAugmentedUnison = OrderedSpelledInterval(.double, .augmented, .unison)
    ///     let tripleDiminishedFourth = OrderedSpelledInterval(.triple, .diminished, .fourth)
    ///
    public init(
        _ degree: Quality.Extended.Degree,
        _ quality: Quality.Extended.AugmentedOrDiminished,
        _ ordinal: Number.Imperfect
    )
    {
        self.quality = .extended(.init(degree, quality))
        self.ordinal = .imperfect(ordinal)
    }

    /// Creates an augmented or diminished `OrderedSpelledInterval` with a perfect number. These
    /// intervals can be up to quintuple augmented or diminished.
    ///
    ///     let doubleAugmentedUnison = OrderedSpelledInterval(.double, .augmented, .unison)
    ///     let tripleDiminishedFourth = OrderedSpelledInterval(.triple, .diminished, .fourth)
    ///
    public init(
        _ degree: Quality.Extended.Degree,
        _ quality: Quality.Extended.AugmentedOrDiminished,
        _ ordinal: Number.Perfect
    )
    {
        self.quality = .extended(.init(degree, quality))
        self.ordinal = .perfect(ordinal)
    }

    /// Creates an `UnorderedDiatonicInterval` with a given `quality` and `number`.
    ///
    ///     let minorSecond = UnorderedDiatonicInterval(.minor, .second)
    ///     let augmentedSixth = UnorderedDiatonicInterval(.augmented, .sixth)
    ///
    public init(_ quality: Quality, _ ordinal: Number) {
        self.quality = quality
        self.ordinal = ordinal
    }

    /// Creates an `UnorderedDiatonicInterval` from an ordered one. This inverts intervals with
    /// ordinals larger than a `.fourth`.
    public init(_ ordered: DiatonicInterval) {
        self.ordinal = Number(ordered.number)
        self.quality = ordered.quality
    }
}

extension UnorderedDiatonicInterval: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of UnorderedIntervalDescriptor.
    public var description: String {
        return quality.description + "\(ordinal.steps + 1)"
    }
}

extension UnorderedDiatonicInterval: Additive {

    /// The unison identity element.
    public static var zero: UnorderedDiatonicInterval = .unison

    /// - Returns: The sum of two `UnorderedDiatonicInterval` values.
    public static func + (lhs: UnorderedDiatonicInterval, rhs: UnorderedDiatonicInterval)
        -> UnorderedDiatonicInterval
    {
        return UnorderedDiatonicInterval(
            DiatonicInterval(lhs) + DiatonicInterval(rhs)
        )
    }
}

extension UnorderedDiatonicInterval.Number: Equatable { }
extension UnorderedDiatonicInterval.Number: Hashable { }
extension UnorderedDiatonicInterval: Equatable { }
extension UnorderedDiatonicInterval: Hashable { }

extension UnorderedDiatonicInterval.Number {

    /// - Returns: The _ideal_ interval in semitones for this given `Ordinal`.
    ///
    /// - Note: It is _ideal_ in the sense that the value for a `.second` is `1.5`: it is neither
    ///  `.major` (`2`) nor `.minor` (`1`), but is instead somewhere in between. This interval
    ///  of course doesn't exist in the wild (in the chromatic wild which we are dealing with), but
    ///  it is used to calculate interval descriptors from step and semitones distances between
    ///  `*IntervalDescriptor` values.
    ///
    var idealInterval: Double {
        switch self {
        case .perfect(let perfect):
            switch perfect {
            case .unison: return 0
            case .fourth: return 5
            }
        case .imperfect(let imperfect):
            switch imperfect {
            case .second: return 1.5
            case .third: return 3.5
            }
        }
    }
}
