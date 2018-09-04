//
//  Voice.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import DataStructures

/// Model of a single `Voice` in a `PerformanceContext`.
public struct Voice: Equatable, Hashable {
    
    /// Identifier.
    let identifier: Int
    
    /// Create a `Voice` with a given `identifier`.
    public init(_ identifier: Int) {
        self.identifier = identifier
    }
}

public typealias VoiceID = Identifier<Voice>
