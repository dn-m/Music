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

public struct Rhythm <T: Equatable> {
    public let metricalDurationTree: MetricalDurationTree
    public let leaves: [RhythmLeaf<T>]
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

    public init(
        _ metricalDurationTree: MetricalDurationTree,
        _ leafContexts: [MetricalContext<T>]
    )
    {
        self.metricalDurationTree = metricalDurationTree
        self.leaves = zip(metricalDurationTree.leaves, leafContexts).map(RhythmLeaf.init)
    }
}

public func lengths <S,T> (of rhythmTrees: S) -> [MetricalDuration]
    where S: Sequence, S.Element == Rhythm<T>
{
    func merge(
        _ leaves: ArraySlice<RhythmLeaf<T>>,
        into accum: [MetricalDuration],
        tied: MetricalDuration?
    ) -> [MetricalDuration]
    {

        guard let (leaf, remaining) = leaves.destructured else {
            return accum + tied
        }

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

/// - returns: `RhythmTree` with the given `MetricalDurationTree` and `MetricalContext` values.
public func * <T> (lhs: MetricalDurationTree, rhs: [MetricalContext<T>]) -> Rhythm<T> {
    return Rhythm(lhs, rhs)
}
