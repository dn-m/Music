//
//  IntervalQuality.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Algebra
import DataStructures

/// The quality of an interval between two `Pitch` values.
public enum IntervalQuality: Invertible {

    // MARK: - Cases

    /// Perfect interval qualities (e.g., perfect).
    case perfect(Perfect)

    /// Imperfect interval qualities (e.g., major or minor).
    case imperfect(Imperfect)

    /// Extended interval qualities (e.g., augmented or diminished).
    case extended(Extended)
}

extension IntervalQuality {

    // MARK: - Nested Types

    /// A perfect interval quality.
    public enum Perfect {

        // MARK: - Cases

        /// Perfect interval quality.
        case perfect
    }

    /// An imperfect interval quality.
    public enum Imperfect: InvertibleEnum {

        // MARK: - Cases

        /// Major interval quality.
        case major

        /// Minor interval quality.
        case minorn
    }

    /// An augmented or diminished interval quality
    public struct Extended: Invertible {

        // MARK: Instance Properties

        /// - Returns: Inversion of `self`.
        public var inverse: Extended {
            return Extended(degree, quality.inverse)
        }

        /// Whether this `Extended` quality is augmented or diminished
        let quality: AugmentedOrDiminished

        /// The degree to which this quality is augmented or diminished (e.g., double augmented,
        /// etc.)
        let degree: Degree

        // MARK: Initializers

        /// Createss an `Extended` `NamedIntervalQuality` with the given `degree` and `quality.`
        public init(_ degree: Degree = .single, _ quality: AugmentedOrDiminished) {
            self.degree = degree
            self.quality = quality
        }
    }
}

extension IntervalQuality.Extended {

    // MARK: - Nested Types

    /// Either augmented or diminished
    public enum AugmentedOrDiminished: InvertibleEnum {

        // MARK: - Cases

        /// Augmented extended interval quality.
        case augmented

        /// Diminished extended interval quality.
        case diminished
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

extension IntervalQuality {

    // MARK: - Instance Properties

    /// - Returns: Inversion of `self`
    public var inverse: IntervalQuality {
        switch self {
        case .perfect:
            return .perfect(.perfect)
        case .imperfect(let quality):
            return .imperfect(quality.inverse)
        case .extended(let quality):
            return .extended(quality.inverse)
        }
    }
}

extension IntervalQuality.Extended: Equatable { }
extension IntervalQuality.Extended: Hashable { }
extension IntervalQuality: Equatable { }
extension IntervalQuality: Hashable { }
