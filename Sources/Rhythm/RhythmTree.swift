//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Restructure
import Math
import MetricalDuration

public struct Rhythm <T> {
    public let metricalDurationTree: MetricalDurationTree
    public let leaves: [Leaf]
}

extension Rhythm {

    public func map <U> (_ transform: @escaping (T) -> U) -> Rhythm<U> {
        return Rhythm<U>(
            metricalDurationTree: metricalDurationTree,
            leaves: leaves.map { $0.map(transform) }
        )
    }
}

extension Rhythm {

    public init(_ metricalDurationTree: MetricalDurationTree, _ leaves: [MetricalContext<T>]) {
        self.metricalDurationTree = metricalDurationTree
        self.leaves = zip(metricalDurationTree.leaves, leaves).map(Leaf.init)
    }
}

public func lengths <S,T> (of rhythmTrees: S) -> [MetricalDuration]
    where S: Sequence, S.Element == Rhythm<T>
{
    func merge(
        _ leaves: ArraySlice<Rhythm<T>.Leaf>,
        into accum: [MetricalDuration],
        tied: MetricalDuration?
    ) -> [MetricalDuration]
    {
        guard let (leaf, remaining) = leaves.destructured else { return accum + tied }

        switch leaf.context {

        case .continuation:
            let tied = (tied ?? .zero) + leaf.metricalDuration
            return merge(remaining, into: accum, tied: tied)

        case .instance(let absenceOrEvent):
            let newAccum: [MetricalDuration]
            let newTied: MetricalDuration?
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

    return merge(ArraySlice(rhythmTrees.flatMap { $0.leaves }), into: [], tied: nil)
}

extension Rhythm {

    /// Leaf item of a hierarchically-structured `Rhythm`.
    public struct Leaf {

        public let metricalDuration: MetricalDuration
        public let context: MetricalContext<T>

        public init(metricalDuration: MetricalDuration, context: MetricalContext<T>) {
            self.metricalDuration = metricalDuration
            self.context = context
        }

        public func map <U> (_ transform: @escaping (T) -> U) -> Rhythm<U>.Leaf {

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
}

extension Rhythm.Leaf: Equatable where T: Equatable { }

/// - returns: `RhythmTree` with the given `MetricalDurationTree` and `MetricalContext` values.
public func * <T> (lhs: MetricalDurationTree, rhs: [MetricalContext<T>]) -> Rhythm<T> {
    return Rhythm(lhs, rhs)
}
