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
public struct CompoundIntervalDescriptor: IntervalDescriptor {

    // MARK: - Instance Properties

    /// The base interval descriptor.
    public let interval: OrderedIntervalDescriptor

    /// The amount of octaves displaced.
    public let octaveDisplacement: Int
}

extension CompoundIntervalDescriptor {

    // MARK: - Initializers

    /// Creates a `CompoundIntervalDescriptor` with the given `interval` and the amount of `octaves`
    /// of displacement.
    public init(_ interval: OrderedIntervalDescriptor, displacedBy octaves: Int = 0) {
        self.interval = interval
        self.octaveDisplacement = octaves
    }

    /// Creates a `CompoundIntervalDescriptor` with the given `quality` and the given `ordinal`,
    /// with no octave displacement.
    public init(_ quality: IntervalQuality, _ ordinal: OrderedIntervalDescriptor.Ordinal) {
        self.init(OrderedIntervalDescriptor(quality,ordinal))
    }
}

extension CompoundIntervalDescriptor: AdditiveGroup {

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
        -> CompoundIntervalDescriptor {
        let semitones = lhs.interval.semitones + rhs.interval.semitones
        let steps = lhs.interval.ordinal.steps + rhs.interval.ordinal.steps
        let stepsModuloOctave = mod(steps,7)
        let octaves = steps / 7
        let interval = OrderedIntervalDescriptor(interval: semitones, steps: stepsModuloOctave)
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
        -> CompoundIntervalDescriptor {
        let semitones = lhs.interval.semitones - rhs.interval.semitones
        let steps = lhs.interval.ordinal.steps - rhs.interval.ordinal.steps
        let stepsModuloOctave = mod(steps,7)
        let octaves = steps / 7
        let interval = OrderedIntervalDescriptor(interval: semitones, steps: stepsModuloOctave)
        return CompoundIntervalDescriptor(steps >= 0 ? interval : interval.inverse,
            displacedBy: octaves
        )
    }

    /// Mutates the left-hand-side by subtracting the right-hand-side.
    public static func -= (lhs: inout Self, rhs: Self) {
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

    /// Unison.
    public static let unison = CompoundIntervalDescriptor(.unison)

    /// Minor second.
    public static let m2 = CompoundIntervalDescriptor(.m2)

    /// Major second.
    public static let M2 = CompoundIntervalDescriptor(.M2)

    /// Minor third.
    public static let m3 = CompoundIntervalDescriptor(.m3)

    /// Major third.
    public static let M3 = CompoundIntervalDescriptor(.M3)

    /// Diminished fourth.
    public static let d4 = CompoundIntervalDescriptor(.d4)

    /// Perfect fourth.
    public static let P4 = CompoundIntervalDescriptor(.P4)

    /// Augmented fourth.
    public static let A4 = CompoundIntervalDescriptor(.A4)

    /// Diminished fifth.
    public static let d5 = CompoundIntervalDescriptor(.d5)

    /// Perfect fifth.
    public static let P5 = CompoundIntervalDescriptor(.P5)

    /// Augmented fifth.
    public static let A5 = CompoundIntervalDescriptor(.A5)

    /// Minor sixth.
    public static let m6 = CompoundIntervalDescriptor(.m6)

    /// Major sixth.
    public static let M6 = CompoundIntervalDescriptor(.M6)

    /// Minor seventh.
    public static let m7 = CompoundIntervalDescriptor(.m7)

    /// Major seventh.
    public static let M7 = CompoundIntervalDescriptor(.M7)

    /// Octave.
    public static let octave = CompoundIntervalDescriptor(.unison, displacedBy: 1)

    // TODO: Add intervals spanning more than one octave
}

extension CompoundIntervalDescriptor: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of CompoundIntervalDescriptor.
    public var description: String {
        return(
            interval.quality.description +
            "\(interval.ordinal.steps + octaveDisplacement * 7 + 1)" +
            (interval.direction == .descending ? "↓" : "")
        )
    }
}

extension CompoundIntervalDescriptor: Equatable { }
extension CompoundIntervalDescriptor: Hashable { }

extension IntervalQuality {
    init(distance: Double, with platonicThreshold: Double) {
        let (diminished, augmented) = (-platonicThreshold,platonicThreshold)
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

extension IntervalDescriptor {

    /// Creates a `IntervalDescriptor`-conforming type with the given `interval` (i.e., the distance
    /// between the `NoteNumber` representations of `Pitch` or `Pitch.Class` values) and the given
    /// `steps` (i.e., the distance between the `LetterName` attributes of `Pitch.Spelling`
    /// values).
    init(interval: Double, steps: Int) {
        let (quality,ordinal) = Self.qualityAndOrdinal(interval: interval, steps: steps)
        self.init(quality,ordinal)
    }

    /// - Returns the `IntervalQuality` and `Ordinal` values for the given `interval` (i.e.,
    /// the distance between the `NoteNumber` representations of `Pitch` or `Pitch.Class` values)
    /// and the given `steps (i.e., the distance between the `LetterName` attributes of
    ///`Pitch.Spelling`  values).
    static func qualityAndOrdinal(interval: Double, steps: Int) -> (IntervalQuality, Ordinal) {
        let distance = Ordinal.platonicDistance(from: interval, to: steps)
        let ordinal = Ordinal(steps: steps)!
        let quality = IntervalQuality(distance: distance, with: ordinal.platonicThreshold)
        return (quality, ordinal)
    }
}



extension OrderedIntervalDescriptor.Ordinal {

    /// - Returns: The distance in semitones from an iedal interval at which point an interval
    /// quality becomes diminished or augmented for a given `Ordinal`.
    public var platonicThreshold: Double {
        switch self {
        case .perfect:
            return 1
        case .imperfect:
            return 1.5
        }
    }
}

extension UnorderedIntervalDescriptor.Ordinal {

    /// - Returns: The distance in semitones from an iedal interval at which point an interval
    /// quality becomes diminished or augmented for a given `Ordinal`.
    public var platonicThreshold: Double {
        switch self {
        case .perfect:
            return 1
        case .imperfect:
            return 1.5
        }
    }
}

extension IntervalOrdinal {

    /// - Returns: The distance of the given `interval` to the `idealSemitoneInterval` from the given
    /// `steps`.
    static func platonicDistance(from interval: Double, to steps: Int) -> Double {
        let ideal = idealSemitoneInterval(steps: steps)
        let difference = interval - ideal
        let normalized = mod(difference + 6, 12) - 6
        let result = steps == 0 ? abs(normalized) : normalized
        return result
    }
}

extension OrderedIntervalDescriptor.Ordinal {

    // FIXME: Harmonize with `platonic` universe.
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

extension OrderedIntervalDescriptor {
    public var semitones: Double {
        return ordinal.idealInterval + quality.adjustment
    }
}
