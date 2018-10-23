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

    /// Unison.
    public static let unison = CompoundIntervalDescriptor(.unison)
}

extension CompoundIntervalDescriptor: Equatable { }
extension CompoundIntervalDescriptor: Hashable { }
