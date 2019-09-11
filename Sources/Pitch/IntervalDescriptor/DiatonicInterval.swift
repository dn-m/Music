//
//  DiatonicInterval.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Algebra
import DataStructures
import Math

/// Descriptor for ordered interval between two `Pitch` values.
public struct DiatonicInterval: DiatonicIntervalProtocol {

    // MARK: - Instance Properties

    /// The direction of a `OrderedIntervalDescriptor`.
    public let direction: Direction

    /// The `DiatonicIntervalNumber` value of a `OrderedIntervalDescriptor`.
    ///
    /// (e.g., `.unison`, `.second`, `.third`, `.fourth`, `.fifth`, `.sixth`, `.seventh`).
    public let number: Number

    /// The `DiatonicIntervalQuality` value of a `OrderedIntervalDescriptor`.
    ///
    /// (e.g., `.diminished`, `.minor`, `.perfect`, `.major`, `.augmented`).
    public let quality: Quality
}

extension DiatonicInterval {

    // MARK: - Initializers

    /// Creates an `DiatonicInterval` with the given `direction`, `number`, and `quality`.
    public init(
        _ direction: Direction = .ascending,
        _ ordinal: Number,
        _ quality: Quality
    ) {
        self.direction = direction
        self.number = ordinal
        self.quality = quality
    }

    /// Creates an `DiatonicInterval` with the given unordered one.
    public init(_ unordered: UnorderedDiatonicInterval) {
        self.number = Number(unordered.ordinal)
        self.quality = unordered.quality
        self.direction = .ascending
    }

    /// Creates an `DiatonicInterval` with the given compound one.
    public init(_ compound: CompoundDiatonicInterval) {
        self = compound.interval
    }
}

extension DiatonicInterval {

    // MARK: - Computed Properties

    /// - Returns: The amount of semitones in this `OrderedIntervalDescriptor`.
    public var semitones: Double {
        switch quality {
        case let .extended(extended):
            switch extended.quality {
            case .augmented:
                return number.idealInterval + quality.adjustment + (number.augDimThreshold - 1)
            case .diminished:
                return number.idealInterval + quality.adjustment - (number.augDimThreshold - 1)
            }
        default:
            return number.idealInterval + quality.adjustment
        }
    }

    /// - Returns: The amount of letter name steps in this `OrderedIntervalDescriptor`.
    public var steps: Int { return number.steps }
}

extension DiatonicInterval {

    // MARK: - Nested Types

    /// Direction of a `DiatonicInterval`.
    public enum Direction: InvertibleEnum {
        case ascending, descending
    }

    /// Ordinal for `DiatonicInterval`.
    public enum Number: DiatonicIntervalNumber {

        // MARK: - Cases

        /// Perfect ordered interval ordinal (unison, fourth, or fifth).
        case perfect(Perfect)

        /// Imperfect ordered interval ordinal (second, third, sixth, or seventh).
        case imperfect(Imperfect)

        /// - Returns: Inversion of `self`.
        ///
        ///     let third: Ordinal = .imperfect(.third)
        ///     third.inverse // => .imperfect(.sixth)
        ///     let fifth: Ordinal = .perfect(.fifth)
        ///     fifth.inverse // => .perfect(.fourth)
        ///
        public var inverse: DiatonicInterval.Number {
            switch self {
            case .perfect(let ordinal):
                return .perfect(ordinal.inverse)
            case .imperfect(let ordinal):
                return .imperfect(ordinal.inverse)
            }
        }

        /// The amount of diatonic steps represented by this `OrderedIntervalDescriptor.Ordinal`.
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

extension DiatonicInterval.Number {

    // MARK: - Nested Types

    /// Perfect `Number` cases.
    public enum Perfect: Int, InvertibleEnum {

        // MARK: - Cases

        /// Fourth perfect ordered interval ordinal.
        case fourth = 3

        /// Unison perfect ordered interval ordinal.
        case unison = 0

        /// Fifth perfect ordered interval ordinal.
        case fifth = 4
    }

    /// Imperfect `Number` cases
    public enum Imperfect: Int, InvertibleEnum {

        // MARK: - Cases

        /// Second imperfect ordered interval ordinal.
        case second = 1

        /// Third imperfect ordered interval ordinal.
        case third = 2

        /// Sixth imperfect ordered interval ordinal.
        case sixth = 5

        /// Seventh imperfect ordered interval ordinal.
        case seventh = 6
    }
}

extension DiatonicInterval.Number {

    // MARK: - Initializers

    /// Creates a `DiatonicInterval` with the given amount of `steps`.
    public init?(steps: Int) {
        switch steps {
        case 0: self = .perfect(.unison)
        case 1: self = .imperfect(.second)
        case 2: self = .imperfect(.third)
        case 3: self = .perfect(.fourth)
        case 4: self = .perfect(.fifth)
        case 5: self = .imperfect(.sixth)
        case 6: self = .imperfect(.seventh)
        default: return nil
        }
    }

    /// Creates an `DiatonicInterval` with the given `unordered` interval.
    ///
    /// - Warning: This is a lossless conversion.
    ///
    public init(_ unordered: UnorderedDiatonicInterval.Number) {
        switch unordered {
        case .perfect(let perfect):
            switch perfect {
            case .unison:
                self = .perfect(.unison)
            case .fourth:
                self = .perfect(.fourth)
            }
        case .imperfect(let imperfect):
            switch imperfect {
            case .second:
                self = .imperfect(.second)
            case .third:
                self = .imperfect(.third)
            }
        }
    }
}

extension DiatonicInterval {

    // MARK: - Type Properties

    /// Diminished unison.
    public static let d1 = DiatonicInterval(.diminished, .unison)

    /// Unison.
    public static let unison = DiatonicInterval(.perfect, .unison)

    /// Diminished second.
    public static let d2 = DiatonicInterval(.diminished, .second)

    /// Augmented Unison.
    public static let A1 = DiatonicInterval(.augmented, .unison)

    /// Minor second.
    public static let m2 = DiatonicInterval(.minor, .second)

    /// Major second.
    public static let M2 = DiatonicInterval(.major, .second)

    /// Diminished third.
    public static let d3 = DiatonicInterval(.diminished, .third)

    /// Augmented second.
    public static let A2 = DiatonicInterval(.augmented, .second)

    /// Minor third.
    public static let m3 = DiatonicInterval(.minor, .third)

    /// Major third.
    public static let M3 = DiatonicInterval(.major, .third)

    /// Diminished fourth.
    public static let d4 = DiatonicInterval(.diminished, .fourth)

    /// Augmented third.
    public static let A3 = DiatonicInterval(.augmented, .third)

    /// Perfect fourth.
    public static let P4 = DiatonicInterval(.perfect, .fourth)

    /// Augmented fourth.
    public static let A4 = DiatonicInterval(.augmented, .fourth)

    /// Diminished fifth
    public static let d5 = DiatonicInterval(.diminished, .fifth)

    /// Perfect fifth.
    public static let P5 = DiatonicInterval(.perfect, .fifth)

    /// Diminished sixth.
    public static let d6 = DiatonicInterval(.diminished, .sixth)

    /// Augmented fifth.
    public static let A5 = DiatonicInterval(.augmented, .fifth)

    /// Minor sixth.
    public static let m6 = DiatonicInterval(.minor, .sixth)

    /// Major sixth.
    public static let M6 = DiatonicInterval(.major, .sixth)

    /// Diminished seventh.
    public static let d7 = DiatonicInterval(.diminished, .seventh)

    /// Augmented sixth.
    public static let A6 = DiatonicInterval(.augmented, .sixth)

    /// Minor seventh.
    public static let m7 = DiatonicInterval(.minor, .seventh)

    /// Major seventh.
    public static let M7 = DiatonicInterval(.major, .seventh)

    /// Augmented seventh.
    public static let A7 = DiatonicInterval(.augmented, .seventh)
}

extension DiatonicInterval: AdditiveGroup {

    /// The `.unison` is the `Additive` `zero`.
    public static var zero: DiatonicInterval = .unison

    /// - Returns: The sum of two `DiatonicInterval` values.
    public static func + (lhs: DiatonicInterval, rhs: DiatonicInterval)
        -> DiatonicInterval
    {
        let semitones = lhs.semitones + rhs.semitones
        let steps = lhs.number.steps + rhs.number.steps
        let stepsModOctave = mod(steps,7)
        let result = DiatonicInterval(interval: Double(semitones), steps: stepsModOctave)
        return result
    }
}

extension DiatonicInterval.Number {

    // MARK: - Type Methods

    /// - Returns: The distance from the given `interval` to the ideal interval for the given amount of `steps`.
    public static func distanceToIdealInterval(for steps: Int, to interval: Double) -> Double {
        let ideal = idealSemitoneInterval(steps: steps)
        let difference = interval - ideal
        return mod(difference + 6, 12) - 6
    }
}

extension DiatonicInterval {

    // MARK: - Initializers

    /// Creates an `DiatonicInterval` with a given `quality` and `number`.
    internal init(_ direction: Direction, _ quality: Quality, _ ordinal: Number) {
        self.direction = direction
        self.quality = quality
        self.number = ordinal
    }

    /// Creates an `DiatonicInterval` with a given `quality` and `number`.
    public init(_ quality: Quality, _ ordinal: Number) {
        self.direction = .ascending
        self.quality = quality
        self.number = ordinal
    }

    /// Creates a perfect `DiatonicInterval`.
    ///
    ///     let perfectFifth = DiatonicInterval(.perfect, .fifth)
    ///
    public init(_ quality: Quality.Perfect, _ ordinal: Number.Perfect) {
        self.direction = .ascending
        self.quality = .perfect(.perfect)
        self.number = .perfect(ordinal)
    }

    /// Creates a perfect `DiatonicInterval` with a given `direction`.
    ///
    ///     let descendingPerfectFifth = DiatonicInterval(.descending, .perfect, .fifth)
    ///
    public init(_ direction: Direction, _ quality: Quality.Perfect, _ ordinal: Number.Perfect) {
        self.direction = direction
        self.quality = .perfect(.perfect)
        self.number = .perfect(ordinal)
    }

    /// Creates an imperfect `DiatonicInterval`.
    ///
    ///     let majorSecond = DiatonicInterval(.major, .second)
    ///     let minorThird = DiatonicInterval(.minor, .third)
    ///     let majorSixth = DiatonicInterval(.major, .sixth)
    ///     let minorSeventh = DiatonicInterval(.minor, .seventh)
    ///
    public init(_ quality: Quality.Imperfect, _ ordinal: Number.Imperfect) {
        self.direction = .ascending
        self.quality = .imperfect(quality)
        self.number = .imperfect(ordinal)
    }

    /// Creates an imperfect `DiatonicInterval`.
    ///
    ///     let majorSecond = DiatonicInterval(.ascending, .major, .second)
    ///     let minorThird = DiatonicInterval(.descending, .minor, .third)
    ///     let majorSixth = DiatonicInterval(.ascending, .major, .sixth)
    ///     let minorSeventh = DiatonicInterval(.descending, .minor, .seventh)
    ///
    public init(
        _ direction: Direction,
        _ quality: Quality.Imperfect,
        _ ordinal: Number.Imperfect
    ) {
        self.direction = direction
        self.quality = .imperfect(quality)
        self.number = .imperfect(ordinal)
    }

    /// Creates an augmented or diminished `DiatonicInterval` with an imperfect number. These
    /// intervals can be up to quintuple augmented or diminished.
    ///
    ///     let doubleDiminishedSecond = DiatonicInterval(.double, .diminished, .second)
    ///     let tripleAugmentedThird = DiatonicInterval(.triple, .augmented, .third)
    ///
    public init(
        _ degree: Quality.Extended.Degree,
        _ quality: Quality.Extended.AugmentedOrDiminished,
        _ ordinal: Number.Imperfect
    ) {
        self.direction = .ascending
        self.quality = .extended(.init(degree, quality))
        self.number = .imperfect(ordinal)
    }

    /// Creates an augmented or diminished `DiatonicInterval` with a given `direction` and an
    /// imperfect number. These intervals can be up to quintuple augmented or diminished.
    ///
    ///     let doubleDiminishedSecond = DiatonicInterval(.descending, .double, .diminished, .second)
    ///     let tripleAugmentedThird = DiatonicInterval(.ascending, .triple, .augmented, .third)
    ///
    public init(
        _ direction: Direction,
        _ degree: Quality.Extended.Degree,
        _ quality: Quality.Extended.AugmentedOrDiminished,
        _ ordinal: Number.Imperfect
    ) {
        self.direction = direction
        self.quality = .extended(.init(degree, quality))
        self.number = .imperfect(ordinal)
    }

    /// Creates an augmented or diminished `DiatonicInterval` with a perfect number. These
    /// intervals can be up to quintuple augmented or diminished.
    ///
    ///     let doubleAugmentedUnison = DiatonicInterval(.double, .augmented, .unison)
    ///     let tripleDiminishedFourth = DiatonicInterval(.triple, .diminished, .fourth)
    ///
    public init(
        _ degree: Quality.Extended.Degree,
        _ quality: Quality.Extended.AugmentedOrDiminished,
        _ ordinal: Number.Perfect
    ) {
        self.direction = .ascending
        self.quality = .extended(.init(degree, quality))
        self.number = .perfect(ordinal)
    }

    /// Creates an augmented or diminished `DiatonicInterval` with a given `direction` and a
    /// perfect number. These intervals can be up to quintuple augmented or diminished.
    ///
    ///     let doubleAugmentedUnison = DiatonicInterval(.descending, .double, .augmented, .unison)
    ///     let tripleDiminishedFourth = DiatonicInterval(.ascending, .triple, .diminished, .fourth)
    ///
    public init(
        _ direction: Direction,
        _ degree: Quality.Extended.Degree,
        _ quality: Quality.Extended.AugmentedOrDiminished,
        _ ordinal: Number.Perfect
    ) {
        self.direction = direction
        self.quality = .extended(.init(degree, quality))
        self.number = .perfect(ordinal)
    }

    /// Creates an augmented or diminished `DiatonicInterval` with an imperfect number.
    ///
    ///     let diminishedSecond = DiatonicInterval(.diminished, .second)
    ///     let augmentedSixth = DiatonicInterval(.augmented, .sixth)
    ///
    public init(
        _ quality: Quality.Extended.AugmentedOrDiminished,
        _ ordinal: Number.Imperfect
    ) {
        self.direction = .ascending
        self.quality = .extended(.init(.single, quality))
        self.number = .imperfect(ordinal)
    }

    /// Creates an augmented or diminished `DiatonicInterval` with a given `direction` and an
    /// imperfect number.
    ///
    ///     let diminishedSecond = DiatonicInterval(.descending, .diminished, .second)
    ///     let augmentedSixth = DiatonicInterval(.ascending, .augmented, .sixth)
    ///
    public init(
        _ direction: Direction,
        _ quality: Quality.Extended.AugmentedOrDiminished,
        _ ordinal: Number.Imperfect
    ) {
        self.direction = direction
        self.quality = .extended(.init(.single, quality))
        self.number = .imperfect(ordinal)
    }

    /// Creates an augmented or diminished `DiatonicInterval` with a perfect number.
    ///
    ///     let augmentedUnison = DiatonicInterval(.augmented, .unison)
    ///     let diminishedFourth = DiatonicInterval(.diminished, .fourth)
    ///
    public init(_ quality: Quality.Extended.AugmentedOrDiminished, _ ordinal: Number.Perfect) {
        self.direction = .ascending
        self.quality = .extended(.init(.single, quality))
        self.number = .perfect(ordinal)
    }

    /// Creates an augmented or diminished `DiatonicInterval` with a given `direction` and a
    /// perfect number.
    ///
    ///     let augmentedUnison = DiatonicInterval(.ascending, .augmented, .unison)
    ///     let diminishedFourth = DiatonicInterval(.descending, .diminished, .fourth)
    ///
    public init(
        _ direction: Direction,
        _ quality: Quality.Extended.AugmentedOrDiminished,
        _ ordinal: Number.Perfect
    ) {
        self.direction = direction
        self.quality = .extended(.init(.single, quality))
        self.number = .perfect(ordinal)
    }
}

extension DiatonicInterval: Invertible {

    // MARK: - Invertible

    /// - Returns: Inversion of `self`.
    public var inverse: DiatonicInterval {
        return .init(direction.inverse, quality.inverse, number.inverse)
    }
}

extension DiatonicInterval: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of UnorderedIntervalDescriptor.
    public var description: String {
        return "\(quality)\(number.steps + 1)\(direction == .descending ? "↓" : "")"
    }
}

extension DiatonicInterval.Number: Equatable, Hashable { }
extension DiatonicInterval: Equatable, Hashable { }
