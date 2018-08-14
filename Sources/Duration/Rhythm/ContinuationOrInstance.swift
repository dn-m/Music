//
//  ContinuationOrInstance.swift
//  Rhythm
//
//  Created by James Bean on 5/17/18.
//

/// Whether a metrical context is "tied" over from the previous context, or if it is new
/// instance of `Element`.
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
    func map <T> (_ transform: (Element) -> T) -> ContinuationOrInstance<T> {
        switch self {
        case .continuation:
            return .continuation
        case .instance(let value):
            return .instance(transform(value))
        }
    }
}
