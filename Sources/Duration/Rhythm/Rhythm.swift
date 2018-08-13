//
//  Rhythm.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import DataStructures
import Math

/// Hierachical organization of metrical durations and their metrical contexts.
public struct Rhythm <Element> {

    /// Leaf item of a hierarchically-structured `Rhythm`.
    public struct Leaf {

        // MARK: - Instance Properties

        /// `Duration` of `Rhythm.Leaf`.
        public let metricalDuration: Duration

        /// `MetricalContext` of `Rhythm.Leaf`
        public let context: MetricalContext<Element>

        // MARK: - Initializers

        /// Create a `Rhythm.Leaf` with a given `metricalDuration` and `context`.
        public init(metricalDuration: Duration, context: MetricalContext<Element>) {
            self.metricalDuration = metricalDuration
            self.context = context
        }
    }

    /// Hierarchical representation of metrical durations.
    public let metricalDurationTree: DurationTree

    /// Leaf items containing metrical context.
    public let leaves: [Leaf]
}

extension Rhythm {

    // MARK: - Initializers

    /// Create a `Rhythm` with a given `metricalDurationTree` and given `leaves`.
    public init(_ metricalDurationTree: DurationTree, _ leaves: [MetricalContext<Element>]) {
        self.metricalDurationTree = metricalDurationTree
        self.leaves = zip(metricalDurationTree.leaves, leaves).map(Leaf.init)
    }

    /// Create a `Rhythm` with a given `duration` and `leaves.
    public init(
        _ duration: Duration,
        _ leaves: [(duration: Int, context: MetricalContext<Element>)]
    )
    {
        self.init(duration * leaves.map { $0.duration}, leaves.map { $0.context} )
    }

    /// Create an isochronic `Rhythm` with the given `duration` and the given `contexts`.
    public init(_ duration: Duration, _ contexts: [MetricalContext<Element>]) {
        self.init(duration * contexts.map { _ in 1 }, contexts)
    }
}

extension Rhythm {

    /// - Returns: `Rhythm` with each of its `event` (i.e., `.instance(.event(Element))`) values
    /// updated by the given `transform`.
    ///
    /// - Each `continuation` remains so
    /// - Each `.instance(.rest)` remains so
    /// - Each `.instance(.event(T))` is transformed to a `.instance(.event(U))`
    public func map <U> (_ transform: @escaping (Element) -> U) -> Rhythm<U> {
        return Rhythm<U>(
            metricalDurationTree: metricalDurationTree,
            leaves: leaves.map { $0.map(transform) }
        )
    }
}

extension Rhythm.Leaf {

    /// - Returns: `Rhythm.Leaf` with its value updated by the given `transform`.
    public func map <U> (_ transform: @escaping (Element) -> U) -> Rhythm<U>.Leaf {

        // FIXME: Extract this into func. Generics not happy.
        var newContext: MetricalContext<U> {
            switch context {
            case .continuation:
                return .continuation
            case .instance(let instance):
                return .instance(instance.map(transform))
            }
        }

        return Rhythm<U>.Leaf(metricalDuration: metricalDuration, context: newContext)
    }
}

extension Rhythm.Leaf: Equatable where Element: Equatable { }

/// - Returns: The `Duration` values of the leaves of the given `rhythms`, by merging
/// `tied` leaves to their predecesors.
public func lengths <S,T> (of rhythms: S) -> [Duration]
    where S: Sequence, S.Element == Rhythm<T>
{
    func merge <S> (
        _ leaves: S,
        into accum: [Duration],
        tied: Duration?
    ) -> [Duration] where S: Sequence, S.Element == Rhythm<T>.Leaf
    {
        guard let (leaf, remaining) = leaves.destructured else { return accum + tied }

        switch leaf.context {

        case .continuation:
            let tied = (tied ?? .zero) + leaf.metricalDuration
            return merge(remaining, into: accum, tied: tied)

        case .instance(let absenceOrEvent):
            let newAccum: [Duration]
            let newTied: Duration?
            switch absenceOrEvent {
            case .absence:
                newAccum = accum + tied + leaf.metricalDuration
                newTied = nil
            case .event:
                newAccum = accum + tied
                newTied = leaf.metricalDuration
            }
            
            return merge(remaining, into: newAccum, tied: newTied)
        }
    }

    return merge(rhythms.flatMap { $0.leaves }, into: [], tied: nil)
}

/// - returns: `RhythmTree` with the given `DurationTree` and `MetricalContext` values.
public func * <Element> (lhs: DurationTree, rhs: [MetricalContext<Element>]) -> Rhythm<Element> {
    return Rhythm(lhs, rhs)
}
