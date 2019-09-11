//
//  CompoundIntervalDescriptor.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Algebra
import Math

/// A descriptor for intervals between two `Pitch` values which takes into account octave
/// displacement.
public struct CompoundIntervalDescriptor: DiatonicIntervalProtocol {

    // MARK: - Instance Properties

    /// The base interval descriptor.
    public let interval: DiatonicInterval

    /// The amount of octaves displaced.
    public let octaveDisplacement: Int
}

extension CompoundIntervalDescriptor {

    // MARK: - Initializers

    /// Creates a `CompoundIntervalDescriptor` with the given `interval` and the amount of `octaves`
    /// of displacement.
    public init(_ interval: DiatonicInterval, displacedBy octaves: Int = 0) {
        self.interval = interval
        self.octaveDisplacement = octaves
    }

    /// Creates a `CompoundIntervalDescriptor` with the given `quality` and the given `number`,
    /// with no octave displacement.
    public init(_ quality: DiatonicIntervalQuality, _ ordinal: DiatonicInterval.Number) {
        self.init(DiatonicInterval(quality,ordinal))
    }
}

extension CompoundIntervalDescriptor {

    // MARK: - Computed Properties

    /// - Returns: The amount of semitones in this `CompoundIntervalDescriptor`.
    public var semitones: Int { return Int(interval.semitones) + octaveDisplacement * 12 }

    /// - Returns: The amount of letter name steps in this `CompoundIntervalDescriptor`.
    public var steps: Int { return interval.steps + octaveDisplacement * 7 }
}

extension CompoundIntervalDescriptor: Additive {

    // MARK: - Type Methods

    /// The `unison` is the `zero` for the `CompoundIntervalDescriptor` `AdditiveGroup`.
    public static let zero: CompoundIntervalDescriptor = .unison

    /// **Example Usage:**
    ///
    ///     let perfectFifth: CompoundIntervalDescriptor = .P5
    ///     let minorThird: CompoundIntervalDescriptor = .m3
    ///     let minorSeventh = perfectFifth + minorThird // => .m7
    ///
    /// - Returns: The sum of the given `CompoundIntervalDescriptors`.
    public static func + (lhs: CompoundIntervalDescriptor, rhs: CompoundIntervalDescriptor)
        -> CompoundIntervalDescriptor
    {
        let steps = lhs.interval.number.steps + rhs.interval.number.steps
        let octaves = steps / 7
        let interval = DiatonicInterval(lhs) + DiatonicInterval(rhs)
        return CompoundIntervalDescriptor(interval, displacedBy: octaves)
    }

    /// Mutates the left-hand-side by adding the right-hand-side.
    public static func += (lhs: inout CompoundIntervalDescriptor, rhs: CompoundIntervalDescriptor) {
        lhs = lhs + rhs
    }

    /// **Example Usage:**
    ///
    ///     let perfectFifth: CompoundIntervalDescriptor = .P5
    ///     let minorThird: CompoundIntervalDescriptor = .m3
    ///     let majorThird = perfectFifth - minorThird // => .M3
    ///
    /// - Returns: The sum of the given `CompoundIntervalDescriptors`.
    public static func - (lhs: CompoundIntervalDescriptor, rhs: CompoundIntervalDescriptor)
        -> CompoundIntervalDescriptor
    {
        let semitones = lhs.interval.semitones - rhs.interval.semitones
        let steps = lhs.steps - rhs.steps
        let stepsModOctave = mod(steps,7)
        let octaves = steps / 7
        let interval = DiatonicInterval(interval: semitones, steps: stepsModOctave)
        return CompoundIntervalDescriptor(
            steps >= 0 ? interval : interval.inverse,
            displacedBy: octaves
        )
    }

    /// Mutates the left-hand-side by subtracting the right-hand-side.
    public static func -= (lhs: inout CompoundIntervalDescriptor, rhs: CompoundIntervalDescriptor) {
        lhs = lhs - rhs
    }

    /// - Returns: The `inverse` of a `CompoundIntervalDescriptor`.
    public static prefix func - (element: CompoundIntervalDescriptor) -> CompoundIntervalDescriptor {
        return element.inverse
    }

    /// - Returns: The `inverse` of a `CompoundIntervalDescriptor`.
    public var inverse: CompoundIntervalDescriptor {
        return CompoundIntervalDescriptor(interval.inverse, displacedBy: -octaveDisplacement)
    }
}

extension CompoundIntervalDescriptor {

    // MARK: - Type Properties

    /// Diminished Unison.
    public static let d1 = CompoundIntervalDescriptor(.d1)

    /// Unison.
    public static let unison = CompoundIntervalDescriptor(.unison)

    /// Diminished second.
    public static let d2 = CompoundIntervalDescriptor(.d2)

    /// Augmented unison.
    public static let A1 = CompoundIntervalDescriptor(.A1)

    /// Minor second.
    public static let m2 = CompoundIntervalDescriptor(.m2)

    /// Major second.
    public static let M2 = CompoundIntervalDescriptor(.M2)

    /// Diminished third.
    public static let d3 = CompoundIntervalDescriptor(.d3)

    /// Augmented second.
    public static let A2 = CompoundIntervalDescriptor(.A2)

    /// Minor third.
    public static let m3 = CompoundIntervalDescriptor(.m3)

    /// Major third.
    public static let M3 = CompoundIntervalDescriptor(.M3)

    /// Diminished fourth.
    public static let d4 = CompoundIntervalDescriptor(.d4)

    /// Augmented third.
    public static let A3 = CompoundIntervalDescriptor(.A3)

    /// Perfect fourth.
    public static let P4 = CompoundIntervalDescriptor(.P4)

    /// Augmented fourth.
    public static let A4 = CompoundIntervalDescriptor(.A4)

    /// Diminished fifth.
    public static let d5 = CompoundIntervalDescriptor(.d5)

    /// Perfect fifth.
    public static let P5 = CompoundIntervalDescriptor(.P5)

    /// Diminished sixth.
    public static let d6 = CompoundIntervalDescriptor(.d6)

    /// Augmented fifth.
    public static let A5 = CompoundIntervalDescriptor(.A5)

    /// Minor sixth.
    public static let m6 = CompoundIntervalDescriptor(.m6)

    /// Major sixth.
    public static let M6 = CompoundIntervalDescriptor(.M6)

    /// Diminished seventh.
    public static let d7 = CompoundIntervalDescriptor(.d7)

    /// Augmented sixth.
    public static let A6 = CompoundIntervalDescriptor(.A6)

    /// Minor seventh.
    public static let m7 = CompoundIntervalDescriptor(.m7)

    /// Major seventh.
    public static let M7 = CompoundIntervalDescriptor(.M7)

    /// Octave.
    public static let octave = CompoundIntervalDescriptor(.unison, displacedBy: 1)

    /// Augmented seventh.
    public static let A7 = CompoundIntervalDescriptor(.A7)

    /// Diminished octave.
    public static let d8 = CompoundIntervalDescriptor(.d1, displacedBy: 1)

    /// Diminished ninth.
    public static let d9 = CompoundIntervalDescriptor(.d2, displacedBy: 1)

    /// Augmented octave.
    public static let A8 = CompoundIntervalDescriptor(.A1, displacedBy: 1)

    /// Minor ninth.
    public static let m9 = CompoundIntervalDescriptor(.m2, displacedBy: 1)

    /// Major ninth.
    public static let M9 = CompoundIntervalDescriptor(.M2, displacedBy: 1)

    /// Diminished tenth.
    public static let d10 = CompoundIntervalDescriptor(.d3, displacedBy: 1)

    /// Augmented ninth.
    public static let A9 = CompoundIntervalDescriptor(.A2, displacedBy: 1)

    /// Minor tenth.
    public static let m10 = CompoundIntervalDescriptor(.m3, displacedBy: 1)

    /// Major tenth.
    public static let M10 = CompoundIntervalDescriptor(.M3, displacedBy: 1)

    /// Diminished eleventh.
    public static let d11 = CompoundIntervalDescriptor(.d4, displacedBy: 1)

    /// Perfect eleventh.
    public static let P11 = CompoundIntervalDescriptor(.P4, displacedBy: 1)

    /// Augmented eleventh.
    public static let A11 = CompoundIntervalDescriptor(.A4, displacedBy: 1)

    /// Diminished twelfth.
    public static let d12 = CompoundIntervalDescriptor(.d5, displacedBy: 1)

    /// Perfect twelfth.
    public static let P12 = CompoundIntervalDescriptor(.P5, displacedBy: 1)

    /// Diminished thirteenth.
    public static let d13 = CompoundIntervalDescriptor(.d6, displacedBy: 1)

    /// Augmented twelfth.
    public static let A12 = CompoundIntervalDescriptor(.A5, displacedBy: 1)

    /// Minor thirteenth.
    public static let m13 = CompoundIntervalDescriptor(.m6, displacedBy: 1)

    /// Major thirteenth.
    public static let M13 = CompoundIntervalDescriptor(.M6, displacedBy: 1)

    /// Diminished fourteenth.
    public static let d14 = CompoundIntervalDescriptor(.d7, displacedBy: 1)

    /// Augmented thirteenth.
    public static let A13 = CompoundIntervalDescriptor(.A6, displacedBy: 1)

    /// Minor fourteenth.
    public static let m14 = CompoundIntervalDescriptor(.m7, displacedBy: 1)

    /// Major fourteenth.
    public static let M14 = CompoundIntervalDescriptor(.M7, displacedBy: 1)

    /// Augmented fourteenth.
    public static let A14 = CompoundIntervalDescriptor(.A7, displacedBy: 1)
}

extension CompoundIntervalDescriptor {

    // MARK: - Type Methods

    /// - Returns: The distance from the given `interval` to the ideal interval for the given amount of `steps`.
    public static func distanceToIdealInterval(for steps: Int, from interval: Double) -> Double {
        let ideal = idealSemitoneInterval(steps: steps)
        let difference = interval - ideal
        let normalized = mod(difference + 6, 12) - 6
        return steps == 0 ? abs(normalized) : normalized
    }
}

extension CompoundIntervalDescriptor: CustomStringConvertible {

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

extension CompoundIntervalDescriptor: Equatable { }
extension CompoundIntervalDescriptor: Hashable { }

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

    /// - Returns the `DiatonicIntervalQuality` and `Number` values for the given `interval` (i.e.,
    /// the distance between the `NoteNumber` representations of `Pitch` or `Pitch.Class` values)
    /// and the given `steps` (i.e., the distance between the `LetterName` attributes of
    ///`Pitch.Spelling`  values).
    static func qualityAndOrdinal(interval: Double, steps: Int) -> (DiatonicIntervalQuality, Number) {
        let distance = Number.distanceToIdealInterval(for: steps, to: interval)
        let ordinal = Number(steps: steps)!
        let quality = DiatonicIntervalQuality(distance: distance, with: ordinal.augDimThreshold)
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

extension UnorderedIntervalDescriptor.Number: WesternScaleMappingOrdinal {

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
