//
//  PerformanceContext.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Foundation

/// Description of the performing forces of a given `Entity`.
public struct PerformanceContext {
    
    /// Particular `Voice` -> `Instrument` -> `Performer` path within a `PerformanceContext`
    /// hierarchy.
    public struct Path: Equatable, Hashable {
    
        /// `Performer.Identifier`
        public let performer: Performer.Identifier
        
        /// `Instrugiment.Identifier`
        public let instrument: Instrument.Identifier
        
        /// `Voice.Identifier`
        public let voice: Voice.Identifier
        
        /// Create a `Path` with identifiers of a `performer`, `instrument`, and `voice`.
        public init(
            _ performer: Performer.Identifier = "P",
            _ instrument: Instrument.Identifier = "I",
            _ voice: Voice.Identifier = 0
        )
        {
            self.performer = performer
            self.instrument = instrument
            self.voice = voice
        }
    }
    

    
    /// `Performer` of a given `PerformanceContext`.
    public let performer: Performer
    
    /// Create a `PerformanceContext` with a `Performer`
    public init(_ performer: Performer = Performer()) {
        self.performer = performer
    }
    
    /// - returns: `true` if this `PerformanceContext` contains the given `Path`.
    public func contains(_ path: Path) -> Bool {
        guard performer.identifier == path.performer else { return false }
        guard let instrument = performer.instruments[path.instrument] else { return false }
        return instrument.voices[path.voice] != nil
    }

//    /// - returns: `true` if `self` is contained by a given `scope`.
//    public func isContained(by scope: Scope) -> Bool {
//        return scope.contains(self)
//    }
}

extension PerformanceContext: Equatable {
    
    /// - returns: `true` if the `performer` values of each `PerformanceContext` are
    /// equivalent.
    public static func == (lhs: PerformanceContext, rhs: PerformanceContext) -> Bool {
        return lhs.performer == rhs.performer
    }
}

