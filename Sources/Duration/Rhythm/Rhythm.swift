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

        /// The metrical identity of a given `Leaf`.
        ///
        /// - "tied": if a leaf is "tied" over from the previous event (`.contiuation`)
        /// - "rest": if a leaf is a "rest", a measured silence (`.instance(.rest)`)
        /// - "event": if a leaf is a measured non-silence (`.instance(.event(Element))`)
        ///
        public typealias Kind = ContinuationOrInstance<AbsenceOrEvent<Element>>

        // MARK: - Instance Properties

        /// `Duration` of `Rhythm.Leaf`.
        public let duration: Duration

        /// `Kind` of `Rhythm.Leaf`
        public let kind: Kind

        // MARK: - Initializers

        /// Create a `Rhythm.Leaf` with a given `duration` and `context`.
        public init(duration: Duration, kind: Leaf.Kind) {
            self.duration = duration
            self.kind = kind
        }
    }

    /// Hierarchical representation of metrical durations.
    public let durationTree: DurationTree

    /// Leaf items containing metrical context.
    public let leaves: [Leaf]
}

extension Rhythm {

    // MARK: - Initializers

    /// Create a `Rhythm` with a given `durationTree` and given `leaves`.
    public init(_ durationTree: DurationTree, _ kinds: [Leaf.Kind]) {
        self.durationTree = durationTree
        self.leaves = zip(durationTree.leaves, kinds).map(Leaf.init)
    }

    /// Create a `Rhythm` with a given `duration` and `leaves.
    public init(
        _ duration: Duration,
        _ leaves: [(duration: Int, context: Leaf.Kind)]
    )
    {
        self.init(duration * leaves.map { $0.duration}, leaves.map { $0.context} )
    }

    /// Create an isochronic `Rhythm` with the given `duration` and the given `contexts`.
    public init(_ duration: Duration, _ contexts: [Leaf.Kind]) {
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
            durationTree: durationTree,
            leaves: leaves.map { $0.map(transform) }
        )
    }
}

extension Rhythm.Leaf {

    /// - Returns: `Rhythm.Leaf` with its value updated by the given `transform`.
    public func map <U> (_ transform: @escaping (Element) -> U) -> Rhythm<U>.Leaf {

        // FIXME: Extract this into func. Generics not happy.
        var newKind: Rhythm<U>.Leaf.Kind {
            switch kind {
            case .continuation:
                return .continuation
            case .instance(let instance):
                return .instance(instance.map(transform))
            }
        }

        return Rhythm<U>.Leaf(duration: duration, kind: newKind)
    }
}

extension Rhythm.Leaf: Equatable where Element: Equatable { }

/// - Returns: The `Duration` values of the leaves of the given `rhythms`, by merging
/// `tied` leaves to their predecesors.
public func lengths <S,T> (of rhythms: S) -> [Duration] where S: Sequence, S.Element == Rhythm<T> {
    func merge <S> (
        _ leaves: S,
        into accum: [Duration],
        tied: Duration?
    ) -> [Duration] where S: Sequence, S.Element == Rhythm<T>.Leaf
    {
        guard let (leaf, remaining) = leaves.destructured else { return accum + tied }
        switch leaf.kind {
        case .continuation:
            let tied = (tied ?? .zero) + leaf.duration
            return merge(remaining, into: accum, tied: tied)
        case .instance(let absenceOrEvent):
            let newAccum: [Duration]
            let newTied: Duration?
            switch absenceOrEvent {
            case .absence:
                newAccum = accum + tied + leaf.duration
                newTied = nil
            case .event:
                newAccum = accum + tied
                newTied = leaf.duration
            }
            return merge(remaining, into: newAccum, tied: newTied)
        }
    }
    return merge(rhythms.flatMap { $0.leaves }, into: [], tied: nil)
}

/// - returns: `Rhythm` with the given `DurationTree` and `Rhythm.Leaf.Kind` values.
public func * <Element> (lhs: DurationTree, rhs: [Rhythm<Element>.Leaf.Kind]) -> Rhythm<Element> {
    return Rhythm(lhs, rhs)
}

/// - Returns: `.continuation` with generic context provided by the external environment.
public func tie <T> () -> Rhythm<T>.Leaf.Kind {
    return .continuation
}

/// - Returns: `.instance(.absence)` with generic context provided by the external environment.
public func rest <T> () -> Rhythm<T>.Leaf.Kind {
    return .instance(.absence)
}

/// - Returns: `.instance(.event(T))` wrapping the given `value`.
public func event <T> (_ value: T) -> Rhythm<T>.Leaf.Kind {
    return .instance(.event(value))
}
