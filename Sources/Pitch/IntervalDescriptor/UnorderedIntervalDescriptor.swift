//
//  UnorderedIntervalDescriptor.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Algorithms
import Math

/// Descriptor for unordered intervals between two `Pitch.Class` values.
public struct UnorderedIntervalDescriptor: IntervalDescriptor {

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

    // MARK: - Nested Types

    /// The ordinal of a `UnorderedIntervalDescriptor`.
    public enum Ordinal: IntervalOrdinal {

        // MARK: - Cases

        /// Imperfect unordered interval ordinals (e.g., unison, fourth).
        case perfect(Perfect)

        /// Perfect unordered interval ordinals (e.g., second, third).
        case imperfect(Imperfect)

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
    public enum Perfect: Int {

        // MARK: - Cases

        /// Unison perfect unordered interval ordinal.
        case unison = 0

        /// Fourth perfect unordered interval ordinal.
        case fourth = 3
    }

    /// Imperfect ordinals.
    public enum Imperfect: Int {

        // MARK: - Cases

        /// Second imperfect unordered interval ordinal.
        case second = 1

        /// Third imperfect unordered interval ordinal.
        case third = 2
    }
}

extension UnorderedIntervalDescriptor {

    // MARK: - Type Properties

    /// Unison.
    public static let unison = UnorderedIntervalDescriptor(.perfect, .unison)

    /// Minor second.
    public static let m2 = UnorderedIntervalDescriptor(.minor, .second)

    /// Major second.
    public static let M2 = UnorderedIntervalDescriptor(.major, .second)

    /// Minor third.
    public static let m3 = UnorderedIntervalDescriptor(.minor, .third)

    /// Major third.
    public static let M3 = UnorderedIntervalDescriptor(.major, .third)

    /// Diminished fourth.
    public static let d4 = UnorderedIntervalDescriptor(.diminished, .fourth)

    /// Perfect fourth.
    public static let P4 = UnorderedIntervalDescriptor(.perfect, .fourth)

    /// Augmented fourth.
    public static let A4 = UnorderedIntervalDescriptor(.augmented, .fourth)
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

    /// Creates a `UnorderedIntervalDescriptor` with a given `quality` and `ordinal`.
    ///
    ///     let minorSecond = UnorderedIntervalDescriptor(.minor, .second)
    ///     let augmentedSixth = UnorderedIntervalDescriptor(.augmented, .sixth)
    ///
    public init(_ quality: IntervalQuality, _ ordinal: Ordinal) {
        self.quality = quality
        self.ordinal = ordinal
    }
}

extension UnorderedIntervalDescriptor.Ordinal: Equatable, Hashable { }
extension UnorderedIntervalDescriptor: Equatable, Hashable { }
