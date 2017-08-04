//
//  Voice.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

/// Model of a single `Voice` in a `PerformanceContext`.
public struct Voice {
    
    /// Type of `Identifier`
    public typealias Identifier = Int
    
    /// Identifier.
    public let identifier: Identifier
    
    /// Create a `Voice` with a given `identifier`.
    public init(_ identifier: Identifier) {
        self.identifier = identifier
    }
}

extension Voice: Equatable {

    // MARK: - Equatable

    /// - returns: `true` if both `Voice` values are equivalent. Otherwise, `false`.
    public static func == (lhs: Voice, rhs: Voice) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Voice: Hashable {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
}
