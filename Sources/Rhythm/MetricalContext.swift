//
//  MetricalContext.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

/// The metrical context of a given `Leaf` (i.e., whether or not the musical event is "tied"
/// from the previous event, and whether or not is a "rest" or an actual event.
public typealias MetricalContext <T: Equatable> = ContinuationOrInstance<AbsenceOrEvent<T>>

/// Whether a metrical context is "tied" over from the previous context, or if it is new
/// instance of the generic `T`.
public enum ContinuationOrInstance <T: Equatable> {

    /// "Tied" over from previous context.
    case continuation

    /// New instance of generic `T`.
    case instance(T)
}

extension ContinuationOrInstance: Equatable {

    /// - returns: `true` if both values are equivalent. Otherwise, `false`.
    public static func == (lhs: ContinuationOrInstance, rhs: ContinuationOrInstance) -> Bool {
        switch (lhs, rhs) {
        case (.continuation, .continuation):
            return true
        case (.instance(let a), .instance(let b)):
            return a == b
        default:
            return false
        }
    }
}

extension ContinuationOrInstance: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printed description.
    public var description: String {
        switch self {
        case .continuation:
            return "-"
        case .instance(let value):
            return "\(value)"
        }
    }
}

/// Whether a context is a "rest" or an actual event of type `T`.
public enum AbsenceOrEvent <T: Equatable> {

    /// "Rest".
    case absence

    /// Actual event of type `T`.
    case event(T)
}

extension AbsenceOrEvent: Equatable {
    /// - returns: `true` if both values are equivalent. Otherwise, `false`.
    public static func == (lhs: AbsenceOrEvent, rhs: AbsenceOrEvent) -> Bool{
        switch (lhs, rhs) {
        case (.absence, .absence):
            return true
        case (.event(let a), .event(let b)):
            return a == b
        default:
            return false
        }
    }
}

extension AbsenceOrEvent: CustomStringConvertible {

    // MARK: - CustomStringConvertible

    /// Printed description.
    public var description: String {
        switch self {
        case .absence:
            return "<>"
        case .event(let value):
            return "\(value)"
        }
    }
}

extension AbsenceOrEvent {

    func map <U> (_ transform: (T) -> U) -> AbsenceOrEvent<U> {
        switch self {
        case .absence:
            return .absence
        case .event(let value):
            return .event(transform(value))
        }
    }
}

extension ContinuationOrInstance {

    func map <U> (_ transform: (T) -> U) -> ContinuationOrInstance<U> {
        switch self {
        case .continuation:
            return .continuation
        case .instance(let value):
            return .instance(transform(value))
        }
    }
}
