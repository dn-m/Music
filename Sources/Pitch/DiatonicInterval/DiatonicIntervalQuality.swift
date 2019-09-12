//
//  DiatonicIntervalQuality.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Algebra
import DataStructures

/// The quality of an interval between two `Pitch` values.
public enum DiatonicIntervalQuality: Invertible {

    // MARK: - Cases

    /// Perfect interval qualities (e.g., perfect).
    case perfect(Perfect)

    /// Imperfect interval qualities (e.g., major or minor).
    case imperfect(Imperfect)

    /// Extended interval qualities (e.g., augmented or diminished).
    case extended(Extended)
}

extension DiatonicIntervalQuality {

    // MARK: - Nested Types

    /// A perfect interval quality.
    public enum Perfect: Double {

        // MARK: - Cases

        /// Perfect interval quality.
        case perfect = 0
    }

    /// An imperfect interval quality.
    public enum Imperfect: Double, InvertibleEnum {

        // MARK: - Cases

        /// Major interval quality.
        case major = 0.5

        /// Minor interval quality.
        case minor = -0.5
    }

    /// An augmented or diminished interval quality
    public struct Extended: Invertible {

        // MARK: Instance Properties

        /// - Returns: The amount of adjustment in semitones from the ideal interval represented by
        /// this `IntervalQuality.Extended`.
        public var adjustment: Double {
            return Double(degree.rawValue) * quality.rawValue
        }

        /// - Returns: Inversion of `self`.
        public var inverse: Extended {
            return Extended(degree, quality.inverse)
        }

        /// Whether this `Extended` quality is augmented or diminished
        public let quality: AugmentedOrDiminished

        /// The degree to which this quality is augmented or diminished (e.g., double augmented,
        /// etc.)
        public let degree: Degree

        // MARK: Initializers

        /// Createss an `Extended` `NamedIntervalQuality` with the given `degree` and `quality.`
        public init(_ degree: Degree = .single, _ quality: AugmentedOrDiminished) {
            self.degree = degree
            self.quality = quality
        }
    }
}

extension DiatonicIntervalQuality.Extended {

    // MARK: - Nested Types

    /// Either augmented or diminished
    public enum AugmentedOrDiminished: Double, InvertibleEnum {

        // MARK: - Cases

        /// Augmented extended interval quality.
        case augmented = 1

        /// Diminished extended interval quality.
        case diminished = -1
    }

    /// The degree to which an `Extended` quality is augmented or diminished.
    public enum Degree: Int {

        /// Single extended interval quality degree.
        case single = 1

        /// Double extended interval quality degree.
        case double = 2

        /// Triple extended interval quality degree.
        case triple = 3

        /// Quadruple extended interval quality degree.
        case quadruple = 4

        /// Quintuple extended interval quality degree.
        case quintuple = 5
    }
}

extension DiatonicIntervalQuality {

    // MARK: - Instance Properties

    /// - Returns: Inversion of `self`
    public var inverse: DiatonicIntervalQuality {
        switch self {
        case .perfect:
            return .perfect(.perfect)
        case .imperfect(let quality):
            return .imperfect(quality.inverse)
        case .extended(let quality):
            return .extended(quality.inverse)
        }
    }

    /// - Returns: The amount of adjustment in semitones from the ideal interval represented by this
    /// `IntervalQuality`.
    public var adjustment: Double {
        switch self {
        case .perfect(let perfect):
            return perfect.rawValue
        case .imperfect(let imperfect):
            return imperfect.rawValue
        case .extended(let extended):
            return extended.adjustment
        }
    }
}

extension DiatonicIntervalQuality.Perfect: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of IntervalQuality.Perfect.
    public var description: String {
        return "P"
    }
}

extension DiatonicIntervalQuality.Imperfect: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of IntervalQuality.Imperfect.
    public var description: String {
        return self == .major ? "M" : "m"
    }
}

extension DiatonicIntervalQuality.Extended.AugmentedOrDiminished: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of IntervalQuality.Extended.AugmentedOrDiminished.
    public var description: String {
        return self == .augmented ? "A" : "d"
    }
}

extension DiatonicIntervalQuality.Extended: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of IntervalQuality.Extended.
    public var description: String {
        return String(repeating: quality.description, count: degree.rawValue)
    }
}

extension DiatonicIntervalQuality: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printable description of IntervalQuality.
    public var description: String {
        switch self {
        case .perfect(let perfect):
            return perfect.description
        case .imperfect(let imperfect):
            return imperfect.description
        case .extended(let extended):
            return extended.description
        }
    }
}

extension DiatonicIntervalQuality.Extended: Equatable { }
extension DiatonicIntervalQuality.Extended: Hashable { }
extension DiatonicIntervalQuality: Equatable { }
extension DiatonicIntervalQuality: Hashable { }
