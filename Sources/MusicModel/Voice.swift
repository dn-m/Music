//
//  Voice.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

/// Model of a single `Voice` in a `PerformanceContext`.
public struct Voice: Equatable, Hashable {
    
    /// Type of `Identifier`
    public typealias Identifier = Int
    
    /// Identifier.
    public let identifier: Identifier
    
    /// Create a `Voice` with a given `identifier`.
    public init(_ identifier: Identifier) {
        self.identifier = identifier
    }
}
