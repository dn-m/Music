//
//  CompoundDiatonicInterval.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Algebra
import Math

/// A descriptor for intervals between two `Pitch` values which takes into account octave
/// displacement.
public struct CompoundDiatonicInterval: DiatonicIntervalProtocol {

    // MARK: - Instance Properties

    /// The base interval descriptor.
    public let interval: DiatonicInterval

    /// The amount of octaves displaced.
    public let octaveDisplacement: Int
}

extension CompoundDiatonicInterval {

    // MARK: - Initializers

    /// Creates a `CompoundDiatonicInterval` with the given `interval` and the amount of `octaves`
    /// of displacement.
    public init(_ interval: DiatonicInterval, displacedBy octaves: Int = 0) {
        self.interval = interval
        self.octaveDisplacement = octaves
    }

    /// Creates a `CompoundDiatonicInterval` with the given `quality` and the given `number`,
    /// with no octave displacement.
    public init(_ quality: Quality, _ ordinal: DiatonicInterval.Number) {
        self.init(DiatonicInterval(quality,ordinal))
    }
}

extension CompoundDiatonicInterval {

    // MARK: - Computed Properties

    /// - Returns: The amount of semitones in this `CompoundIntervalDescriptor`.
    public var semitones: Int { return Int(interval.semitones) + octaveDisplacement * 12 }

    /// - Returns: The amount of letter name steps in this `CompoundIntervalDescriptor`.
    public var steps: Int { return interval.steps + octaveDisplacement * 7 }
}

extension CompoundDiatonicInterval: Additive {

    // MARK: - Type Methods

    /// The `unison` is the `zero` for the `CompoundIntervalDescriptor` `AdditiveGroup`.
    public static let zero: CompoundDiatonicInterval = .unison

    /// **Example Usage:**
    ///
    ///     let perfectFifth: CompoundDiatonicInterval = .P5
    ///     let minorThird: CompoundDiatonicInterval = .m3
    ///     let minorSeventh = perfectFifth + minorThird // => .m7
    ///
    /// - Returns: The sum of the given `CompoundIntervalDescriptors`.
    public static func + (lhs: CompoundDiatonicInterval, rhs: CompoundDiatonicInterval)
        -> CompoundDiatonicInterval
    {
        let steps = lhs.interval.number.steps + rhs.interval.number.steps
        let octaves = steps / 7
        let interval = DiatonicInterval(lhs) + DiatonicInterval(rhs)
        return CompoundDiatonicInterval(interval, displacedBy: octaves)
    }

    /// Mutates the left-hand-side by adding the right-hand-side.
    public static func += (lhs: inout CompoundDiatonicInterval, rhs: CompoundDiatonicInterval) {
        lhs = lhs + rhs
    }

    /// **Example Usage:**
    ///
    ///     let perfectFifth: CompoundDiatonicInterval = .P5
    ///     let minorThird: CompoundDiatonicInterval = .m3
    ///     let majorThird = perfectFifth - minorThird // => .M3
    ///
    /// - Returns: The sum of the given `CompoundIntervalDescriptors`.
    public static func - (lhs: CompoundDiatonicInterval, rhs: CompoundDiatonicInterval)
        -> CompoundDiatonicInterval
    {
        let semitones = lhs.interval.semitones - rhs.interval.semitones
        let steps = lhs.steps - rhs.steps
        let stepsModOctave = mod(steps,7)
        let octaves = steps / 7
        let interval = DiatonicInterval(interval: semitones, steps: stepsModOctave)
        return CompoundDiatonicInterval(
            steps >= 0 ? interval : interval.inverse,
            displacedBy: octaves
        )
    }

    /// Mutates the left-hand-side by subtracting the right-hand-side.
    public static func -= (lhs: inout CompoundDiatonicInterval, rhs: CompoundDiatonicInterval) {
        lhs = lhs - rhs
    }

    /// - Returns: The `inverse` of a `CompoundDiatonicInterval`.
    public static prefix func - (element: CompoundDiatonicInterval) -> CompoundDiatonicInterval {
        return element.inverse
    }

    /// - Returns: The `inverse` of a `CompoundIntervalDescriptor`.
    public var inverse: CompoundDiatonicInterval {
        return CompoundDiatonicInterval(interval.inverse, displacedBy: -octaveDisplacement)
    }
}

extension CompoundDiatonicInterval {

    // MARK: - Type Properties

    /// Diminished Unison.
    public static let d1 = CompoundDiatonicInterval(.d1)

    /// Unison.
    public static let unison = CompoundDiatonicInterval(.unison)

    /// Diminished second.
    public static let d2 = CompoundDiatonicInterval(.d2)

    /// Augmented unison.
    public static let A1 = CompoundDiatonicInterval(.A1)

    /// Minor second.
    public static let m2 = CompoundDiatonicInterval(.m2)

    /// Major second.
    public static let M2 = CompoundDiatonicInterval(.M2)

    /// Diminished third.
    public static let d3 = CompoundDiatonicInterval(.d3)

    /// Augmented second.
    public static let A2 = CompoundDiatonicInterval(.A2)

    /// Minor third.
    public static let m3 = CompoundDiatonicInterval(.m3)

    /// Major third.
    public static let M3 = CompoundDiatonicInterval(.M3)

    /// Diminished fourth.
    public static let d4 = CompoundDiatonicInterval(.d4)

    /// Augmented third.
    public static let A3 = CompoundDiatonicInterval(.A3)

    /// Perfect fourth.
    public static let P4 = CompoundDiatonicInterval(.P4)

    /// Augmented fourth.
    public static let A4 = CompoundDiatonicInterval(.A4)

    /// Diminished fifth.
    public static let d5 = CompoundDiatonicInterval(.d5)

    /// Perfect fifth.
    public static let P5 = CompoundDiatonicInterval(.P5)

    /// Diminished sixth.
    public static let d6 = CompoundDiatonicInterval(.d6)

    /// Augmented fifth.
    public static let A5 = CompoundDiatonicInterval(.A5)

    /// Minor sixth.
    public static let m6 = CompoundDiatonicInterval(.m6)

    /// Major sixth.
    public static let M6 = CompoundDiatonicInterval(.M6)

    /// Diminished seventh.
    public static let d7 = CompoundDiatonicInterval(.d7)

    /// Augmented sixth.
    public static let A6 = CompoundDiatonicInterval(.A6)

    /// Minor seventh.
    public static let m7 = CompoundDiatonicInterval(.m7)

    /// Major seventh.
    public static let M7 = CompoundDiatonicInterval(.M7)

    /// Octave.
    public static let octave = CompoundDiatonicInterval(.unison, displacedBy: 1)

    /// Augmented seventh.
    public static let A7 = CompoundDiatonicInterval(.A7)

    /// Diminished octave.
    public static let d8 = CompoundDiatonicInterval(.d1, displacedBy: 1)

    /// Diminished ninth.
    public static let d9 = CompoundDiatonicInterval(.d2, displacedBy: 1)

    /// Augmented octave.
    public static let A8 = CompoundDiatonicInterval(.A1, displacedBy: 1)

    /// Minor ninth.
    public static let m9 = CompoundDiatonicInterval(.m2, displacedBy: 1)

    /// Major ninth.
    public static let M9 = CompoundDiatonicInterval(.M2, displacedBy: 1)

    /// Diminished tenth.
    public static let d10 = CompoundDiatonicInterval(.d3, displacedBy: 1)

    /// Augmented ninth.
    public static let A9 = CompoundDiatonicInterval(.A2, displacedBy: 1)

    /// Minor tenth.
    public static let m10 = CompoundDiatonicInterval(.m3, displacedBy: 1)

    /// Major tenth.
    public static let M10 = CompoundDiatonicInterval(.M3, displacedBy: 1)

    /// Diminished eleventh.
    public static let d11 = CompoundDiatonicInterval(.d4, displacedBy: 1)

    /// Perfect eleventh.
    public static let P11 = CompoundDiatonicInterval(.P4, displacedBy: 1)

    /// Augmented eleventh.
    public static let A11 = CompoundDiatonicInterval(.A4, displacedBy: 1)

    /// Diminished twelfth.
    public static let d12 = CompoundDiatonicInterval(.d5, displacedBy: 1)

    /// Perfect twelfth.
    public static let P12 = CompoundDiatonicInterval(.P5, displacedBy: 1)

    /// Diminished thirteenth.
    public static let d13 = CompoundDiatonicInterval(.d6, displacedBy: 1)

    /// Augmented twelfth.
    public static let A12 = CompoundDiatonicInterval(.A5, displacedBy: 1)

    /// Minor thirteenth.
    public static let m13 = CompoundDiatonicInterval(.m6, displacedBy: 1)

    /// Major thirteenth.
    public static let M13 = CompoundDiatonicInterval(.M6, displacedBy: 1)

    /// Diminished fourteenth.
    public static let d14 = CompoundDiatonicInterval(.d7, displacedBy: 1)

    /// Augmented thirteenth.
    public static let A13 = CompoundDiatonicInterval(.A6, displacedBy: 1)

    /// Minor fourteenth.
    public static let m14 = CompoundDiatonicInterval(.m7, displacedBy: 1)

    /// Major fourteenth.
    public static let M14 = CompoundDiatonicInterval(.M7, displacedBy: 1)

    /// Augmented fourteenth.
    public static let A14 = CompoundDiatonicInterval(.A7, displacedBy: 1)
}

extension CompoundDiatonicInterval {

    // MARK: - Type Methods

    /// - Returns: The distance from the given `interval` to the ideal interval for the given amount of `steps`.
    public static func distanceToIdealInterval(for steps: Int, from interval: Double) -> Double {
        let ideal = idealSemitoneInterval(steps: steps)
        let difference = interval - ideal
        let normalized = mod(difference + 6, 12) - 6
        return steps == 0 ? abs(normalized) : normalized
    }
}

extension CompoundDiatonicInterval: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of CompoundIntervalDescriptor.
    public var description: String {
        return(
            interval.quality.description +
            "\(interval.number.steps + octaveDisplacement * 7 + 1)" +
            (interval.direction == .descending ? "↓" : "")
        )
    }
}

extension CompoundDiatonicInterval: Equatable { }
extension CompoundDiatonicInterval: Hashable { }

extension DiatonicIntervalQuality {
    init(distance: Double, with augDimThreshold: Double) {
        let (augmented, diminished) = (augDimThreshold,-augDimThreshold)
        switch distance {
        case diminished - 4:
            self = .extended(.init(.quintuple, .diminished))
        case diminished - 3:
            self = .extended(.init(.quadruple, .diminished))
        case diminished - 2:
            self = .extended(.init(.triple, .diminished))
        case diminished - 1:
            self = .extended(.init(.double, .diminished))
        case diminished:
            self = .extended(.init(.single, .diminished))
        case -0.5:
            self = .imperfect(.minor)
        case +0.0:
            self = .perfect(.perfect)
        case +0.5:
            self = .imperfect(.major)
        case augmented:
            self = .extended(.init(.single, .augmented))
        case augmented + 1:
            self = .extended(.init(.double, .augmented))
        case augmented + 2:
            self = .extended(.init(.triple, .augmented))
        case augmented + 3:
            self = .extended(.init(.quadruple, .augmented))
        case augmented + 4:
            self = .extended(.init(.quintuple, .augmented))
        default:
            fatalError("Not possible to create a NamedIntervalQuality with interval \(distance)")
        }
    }
}

/// - Returns: The "ideal" interval for the given amount of scalar steps between two
/// `SpelledPitch` values.
///
/// For example, perfect intervals have a single ideal spelling, whereas imperfect intervals
/// could be spelled two different ways.
func idealSemitoneInterval(steps: Int) -> Double {
    assert((0..<7).contains(steps))
    switch steps {
    case 0:
        return 0
    case 1:
        return 1.5
    case 2:
        return 3.5
    case 3:
        return 5
    case 4:
        return 7
    case 5:
        return 8.5
    case 6:
        return 10.5
    default:
        fatalError("Impossible")
    }
}

extension DiatonicIntervalProtocol where Number: WesternScaleMappingOrdinal {

    /// Creates a `DiatonicIntervalProtocol`-conforming type with the given `interval` (i.e., the distance
    /// between the `NoteNumber` representations of `Pitch` or `Pitch.Class` values) and the given
    /// `steps` (i.e., the distance between the `LetterName` attributes of `Pitch.Spelling`
    /// values).
    init(interval: Double, steps: Int) {
        let (quality,ordinal) = Self.qualityAndOrdinal(interval: interval, steps: steps)
        self.init(quality,ordinal)
    }

    /// - Returns the `Quality` and `Number` values for the given `interval` (i.e.,
    /// the distance between the `NoteNumber` representations of `Pitch` or `Pitch.Class` values)
    /// and the given `steps` (i.e., the distance between the `LetterName` attributes of
    ///`Pitch.Spelling`  values).
    static func qualityAndOrdinal(interval: Double, steps: Int) -> (Quality, Number) {
        let distance = Number.distanceToIdealInterval(for: steps, to: interval)
        let ordinal = Number(steps: steps)!
        let quality = Quality(distance: distance, with: ordinal.augDimThreshold)
        return (quality, ordinal)
    }
}

extension DiatonicInterval.Number: WesternScaleMappingOrdinal {

    /// - Returns: The distance in semitones from an ideal interval at which point an interval
    /// quality becomes diminished or augmented for a given `Ordinal`.
    public var augDimThreshold: Double {
        switch self {
        case .perfect:
            return 1
        case .imperfect:
            return 1.5
        }
    }
}

extension UnorderedDiatonicInterval.Number: WesternScaleMappingOrdinal {

    /// - Returns: The distance in semitones from an ideal interval at which point an interval
    /// quality becomes diminished or augmented for a given `Ordinal`.
    var augDimThreshold: Double {
        switch self {
        case .perfect:
            return 1
        case .imperfect:
            return 1.5
        }
    }
}

extension DiatonicInterval.Number {
    var idealInterval: Double {
        switch self {
        case .perfect(let perfect):
            switch perfect {
            case .unison: return 0
            case .fourth: return 5
            case .fifth: return 7
            }
        case .imperfect(let imperfect):
            switch imperfect {
            case .second: return 1.5
            case .third: return 3.5
            case .sixth: return 8.5
            case .seventh: return 10.5
            }
        }
    }
}
