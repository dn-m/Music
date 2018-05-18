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

/// Whether a metrical context is "tied" over from the previous context, or if it is new
/// instance of the generic `T`.
public enum ContinuationOrInstance <Element> {

    /// Continued ("tied") over from previous context.
    case continuation

    /// New instance of generic `Element`.
    case instance(Element)
}

extension ContinuationOrInstance: Equatable where Element: Equatable { }

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

extension ContinuationOrInstance {

    /// - Returns: An `.continuation` if `.continuation`, otherwise an `.instance` containing the
    /// `Element` transformed by the given `transform`.
    func map <U> (_ transform: (Element) -> U) -> ContinuationOrInstance<U> {
        switch self {
        case .continuation:
            return .continuation
        case .instance(let value):
            return .instance(transform(value))
        }
    }
}
