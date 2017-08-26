//
//  RhythmLeaf.swift
//  Rhythm
//
//  Created by James Bean on 8/26/17.
//

import MetricalDuration

/// - Note: At some point, nest this within `Rhythm`, inheriting `T`. Currently, this produces
/// "Runtime Error: cyclic metadata dependency detected, aborting" (SR-4383).
public struct RhythmLeaf <T: Equatable> {

    public let metricalDuration: MetricalDuration
    public let context: MetricalContext<T>

    public init(metricalDuration: MetricalDuration, context: MetricalContext<T>) {
        self.metricalDuration = metricalDuration
        self.context = context
    }
}

extension RhythmLeaf {

    public func map <U> (_ transform: @escaping (T) -> U) -> RhythmLeaf<U> {

        // FIXME: Extract this into func. Generics not happy.
        var newContext: MetricalContext<U> {
            switch context {
            case .continuation:
                return .continuation
            case .instance(let instance):
                return .instance(instance.map(transform))
            }
        }

        return RhythmLeaf<U>(metricalDuration: metricalDuration, context: newContext)
    }
}

extension RhythmLeaf: Equatable {

    public static func == (lhs: RhythmLeaf<T>, rhs: RhythmLeaf<T>) -> Bool {
        return lhs.metricalDuration == rhs.metricalDuration && lhs.context == rhs.context
    }
}
