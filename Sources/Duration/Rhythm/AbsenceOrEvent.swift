//
//  AbsenceOrEvent.swift
//  Rhythm
//
//  Created by James Bean on 5/17/18.
//

/// Whether a context is a "rest" or an actual event of type `Element`.
public enum AbsenceOrEvent <Element> {

    // MARK: - Cases

    /// "Rest".
    case absence

    /// Actual event containing `Element`.
    case event(Element)
}

extension AbsenceOrEvent: Equatable where Element: Equatable { }

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

    /// - Returns: An `.absence` if `.absence`, otherwise an `.event` containing the `Element`
    /// transformed by the given `transform`.
    func map <T> (_ transform: (Element) -> T) -> AbsenceOrEvent<T> {
        switch self {
        case .absence:
            return .absence
        case .event(let value):
            return .event(transform(value))
        }
    }
}
