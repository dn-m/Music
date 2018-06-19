//
//  MetricalContext.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

/// The metrical context of a given `Leaf` (i.e., whether or not the musical event is "tied"
/// from the previous event, and whether or not is a "rest" or an actual event.
public typealias MetricalContext <Element> = ContinuationOrInstance<AbsenceOrEvent<Element>>

/// - Returns: `.continuation` with generic context provided by the external environment.
public func tie <T> () -> MetricalContext<T> {
    return .continuation
}

/// - Returns: `.instance(.absence)` with generic context provided by the external environment.
public func rest <T> () -> MetricalContext<T> {
    return .instance(.absence)
}

/// - Returns: `.instance(.event(T))` wrapping the given `value`.
public func event <T> (_ value: T) -> MetricalContext<T> {
    return .instance(.event(value))
}
