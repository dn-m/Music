//
//  IntervalDescriptor.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

/// Interface for intervals between two `Pitch` values.
protocol IntervalDescriptor {

    // MARK: - Associated Types

    /// The `IntervalOrdinal`-conforming type for this `IntervalDescriptor`.
    associatedtype Ordinal: IntervalOrdinal

    // MARK: - Initializers

    /// Creates a `IntervalDescriptor` with the given `quality` and the given `ordinal`.
    init(_ quality: IntervalQuality, _ ordinal: Ordinal)
}

extension IntervalDescriptor {

    /// Createss a `IntervalDescriptor`-conforming type with the given `interval` (i.e., the distance
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
    static func qualityAndOrdinal(interval: Double, steps: Int)
        -> (IntervalQuality, Ordinal)
    {
        let distance = Ordinal.platonicDistance(from: interval, to: steps)
        let ordinal = Ordinal(steps: steps)!
        let quality = IntervalQuality(distance: distance, with: ordinal.platonicThreshold)
        return (quality, ordinal)
    }
}

extension IntervalQuality {
    init(distance: Double, with platonicThreshold: Double) {
        let (diminished, augmented) = (-platonicThreshold,platonicThreshold)
        switch distance {
        case diminished - 4:
            self =  .extended(.init(.quintuple, .diminished))
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
