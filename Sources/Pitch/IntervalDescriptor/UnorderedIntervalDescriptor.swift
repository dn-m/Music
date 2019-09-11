//
//  UnorderedIntervalDescriptor.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Algebra
import Algorithms
import DataStructures
import Math

/// Descriptor for unordered intervals between two `Pitch.Class` values.
public struct UnorderedIntervalDescriptor: DiatonicIntervalProtocol {

    // MARK: - Instance Properties

    /// Quality of an `UnorderedIntervalDescriptor`.
    ///
    /// - `diminished`
    /// - `minor`
    /// - `perfect`
    /// - `major`
    /// - `augmented`
    ///
    public let quality: IntervalQuality

    /// Ordinal of an `UnorderedIntervalDescriptor`.
    ///
    /// - `unison`
    /// - `second`
    /// - `third`
    /// - `fourth`
    ///
    public let ordinal: Ordinal
}

extension UnorderedIntervalDescriptor {

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

extension UnorderedIntervalDescriptor {

    // MARK: - Nested Types

    /// The ordinal of a `UnorderedIntervalDescriptor`.
    public enum Ordinal: IntervalOrdinal {

        // MARK: - Cases

        /// Imperfect unordered interval ordinals (e.g., unison, fourth).
        case perfect(Perfect)

        /// Perfect unordered interval ordinals (e.g., second, third).
        case imperfect(Imperfect)

        public var inverse: UnorderedIntervalDescriptor.Ordinal {
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

extension UnorderedIntervalDescriptor.Ordinal {

    // MARK: - Initializers

    /// Createss a `UnorderedIntervalDescriptor` with the given amount of `steps`.
    public init?(steps: Int) {
        switch steps {
        case 0: self = .perfect(.unison)
        case 1: self = .imperfect(.second)
        case 2: self = .imperfect(.third)
        case 3: self = .perfect(.fourth)
        default: return nil
        }
    }

    /// Creates an `UnorderedIntervalDescriptor` with the given `ordered` interval.
    ///
    /// In the case that the `ordered` interval is out of range (e.g., `.fifth`, `.sixth`,
    /// `.seventh`), the `.inverse` is converted into an unordered interval (e.g., a `.seventh`
    /// becomes a `.second`).
    ///
    public init(_ ordered: OrderedIntervalDescriptor.Ordinal) {
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

extension UnorderedIntervalDescriptor.Ordinal {

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

extension UnorderedIntervalDescriptor {

    // MARK: - Type Properties

    /// Diminished unison.
    public static let d1 = UnorderedIntervalDescriptor(.diminished, .unison)

    /// Unison.
    public static let unison = UnorderedIntervalDescriptor(.perfect, .unison)

    /// Diminished second.
    public static let d2 = UnorderedIntervalDescriptor(.diminished, .second)

    /// Augmented unison.
    public static let A1 = UnorderedIntervalDescriptor(.augmented, .unison)

    /// Minor second.
    public static let m2 = UnorderedIntervalDescriptor(.minor, .second)

    /// Major second.
    public static let M2 = UnorderedIntervalDescriptor(.major, .second)

    /// Diminished third.
    public static let d3 = UnorderedIntervalDescriptor(.diminished, .third)

    /// Augmented second.
    public static let A2 = UnorderedIntervalDescriptor(.augmented, .second)

    /// Minor third.
    public static let m3 = UnorderedIntervalDescriptor(.minor, .third)

    /// Major third.
    public static let M3 = UnorderedIntervalDescriptor(.major, .third)

    /// Diminished fourth.
    public static let d4 = UnorderedIntervalDescriptor(.diminished, .fourth)

    /// Augmented third.
    public static let A3 = UnorderedIntervalDescriptor(.augmented, .third)

    /// Perfect fourth.
    public static let P4 = UnorderedIntervalDescriptor(.perfect, .fourth)

    /// Augmented fourth.
    public static let A4 = UnorderedIntervalDescriptor(.augmented, .fourth)
}

extension UnorderedIntervalDescriptor.Ordinal {

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

extension UnorderedIntervalDescriptor {

    // MARK: - Initializers

    // MARK: Perfect Interval Descriptors

    /// Creates a perfect `UnorderedIntervalDescriptor`.
    ///
    ///     let perfectUnison = UnorderedIntervalDescriptor(.perfect, .unison)
    ///     let perfectFourth = UnorderedIntervalDescriptor(.perfect, .fourth)
    ///
    public init(_ quality: IntervalQuality.Perfect, _ ordinal: Ordinal.Perfect) {
        self.quality = .perfect(.perfect)
        self.ordinal = .perfect(ordinal)
    }

    // MARK: Imperfect Interval Descriptors

    /// Creates an imperfect `UnorderedIntervalDescriptor`.
    ///
    ///     let majorSecond = UnorderedIntervalDescriptor(.major, .second)
    ///     let minorThird = UnorderedIntervalDescriptor(.minor, .third)
    ///
    public init(_ quality: IntervalQuality.Imperfect, _ ordinal: Ordinal.Imperfect) {
        self.quality = .imperfect(quality)
        self.ordinal = .imperfect(ordinal)
    }

    // MARK: Augmented or Diminished Interval Descriptors

    /// Creates an augmented or diminished `UnorderedIntervalDescriptor` with an imperfect ordinal.
    ///
    ///     let doubleDiminishedSecond = UnorderedIntervalDescriptor(.diminished, .second)
    ///     let tripleAugmentedThird = UnorderedIntervalDescriptor(.augmented, .third)
    ///
    public init(_ quality: IntervalQuality.Extended.AugmentedOrDiminished, _ ordinal: Ordinal.Imperfect) {
        self.quality = .extended(.init(.single, quality))
        self.ordinal = .imperfect(ordinal)
    }

    /// Creates an augmented or diminished `UnorderedIntervalDescriptor` with a perfect ordinal.
    ///
    ///     let doubleAugmentedUnison = UnorderedIntervalDescriptor(.augmented, .unison)
    ///     let tripleDiminishedFourth = UnorderedIntervalDescriptor(.diminished, .fourth)
    ///
    public init(_ quality: IntervalQuality.Extended.AugmentedOrDiminished, _ ordinal: Ordinal.Perfect) {
        self.quality = .extended(.init(.single, quality))
        self.ordinal = .perfect(ordinal)
    }

    /// Creates an augmented or diminished `UnorderedIntervalDescriptor` with an imperfect ordinal.
    /// These intervals can be up to quintuple augmented or diminished.
    ///
    ///     let doubleAugmentedUnison = OrderedSpelledInterval(.double, .augmented, .unison)
    ///     let tripleDiminishedFourth = OrderedSpelledInterval(.triple, .diminished, .fourth)
    ///
    public init(
        _ degree: IntervalQuality.Extended.Degree,
        _ quality: IntervalQuality.Extended.AugmentedOrDiminished,
        _ ordinal: Ordinal.Imperfect
    )
    {
        self.quality = .extended(.init(degree, quality))
        self.ordinal = .imperfect(ordinal)
    }

    /// Creates an augmented or diminished `OrderedSpelledInterval` with a perfect ordinal. These
    /// intervals can be up to quintuple augmented or diminished.
    ///
    ///     let doubleAugmentedUnison = OrderedSpelledInterval(.double, .augmented, .unison)
    ///     let tripleDiminishedFourth = OrderedSpelledInterval(.triple, .diminished, .fourth)
    ///
    public init(
        _ degree: IntervalQuality.Extended.Degree,
        _ quality: IntervalQuality.Extended.AugmentedOrDiminished,
        _ ordinal: Ordinal.Perfect
    )
    {
        self.quality = .extended(.init(degree, quality))
        self.ordinal = .perfect(ordinal)
    }

    /// Creates an `UnorderedIntervalDescriptor` with a given `quality` and `ordinal`.
    ///
    ///     let minorSecond = UnorderedIntervalDescriptor(.minor, .second)
    ///     let augmentedSixth = UnorderedIntervalDescriptor(.augmented, .sixth)
    ///
    public init(_ quality: IntervalQuality, _ ordinal: Ordinal) {
        self.quality = quality
        self.ordinal = ordinal
    }

    /// Creates an `UnorderedIntervalDescriptor` from an ordered one. This inverts intervals with
    /// ordinals larger than a `.fourth`.
    public init(_ ordered: OrderedIntervalDescriptor) {
        self.ordinal = Ordinal(ordered.ordinal)
        self.quality = ordered.quality
    }
}

extension UnorderedIntervalDescriptor: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of UnorderedIntervalDescriptor.
    public var description: String {
        return quality.description + "\(ordinal.steps + 1)"
    }
}

extension UnorderedIntervalDescriptor: Additive {

    /// The unison identity element.
    public static var zero: UnorderedIntervalDescriptor = .unison

    /// - Returns: The sum of two `UnorderedIntervalDescriptor` values.
    public static func + (lhs: UnorderedIntervalDescriptor, rhs: UnorderedIntervalDescriptor)
        -> UnorderedIntervalDescriptor
    {
        return UnorderedIntervalDescriptor(
            OrderedIntervalDescriptor(lhs) + OrderedIntervalDescriptor(rhs)
        )
    }
}

extension UnorderedIntervalDescriptor.Ordinal: Equatable { }
extension UnorderedIntervalDescriptor.Ordinal: Hashable { }
extension UnorderedIntervalDescriptor: Equatable { }
extension UnorderedIntervalDescriptor: Hashable { }

extension UnorderedIntervalDescriptor.Ordinal {

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
