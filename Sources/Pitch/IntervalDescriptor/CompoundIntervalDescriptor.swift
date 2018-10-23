//
//  CompoundIntervalDescriptor.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

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

    /// Diminished fifth
    public static let d5 = CompoundIntervalDescriptor(.d5)

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

extension CompoundIntervalDescriptor: Equatable { }
extension CompoundIntervalDescriptor: Hashable { }
