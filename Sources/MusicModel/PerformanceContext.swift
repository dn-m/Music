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
    public struct Path {
    
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
    
    public struct Scope {
        
        private let performer: Performer.Identifier?
        private let instrument: Instrument.Identifier?
        private let voice: Voice.Identifier?
        
        /// Create a `Scope` that contains all `PerformanceContext` values.
        public init() {
            self.performer = nil
            self.instrument = nil
            self.voice = nil
        }
        
        /// Create a `Scope` that contains all `PerformanceContext` values with the given
        /// `Performer.Identifier` value.
        public init(_ performer: (Performer.Identifier)) {
            self.performer = performer
            self.instrument = nil
            self.voice = nil
        }
        
        /// Create a `Scope` that contains all `PerformanceContext` values with the given
        /// `Performer.Identifier` and `Instrument.Identifier` values.
        public init(_ performer: Performer.Identifier, _ instrument: Instrument.Identifier) {
            self.performer = performer
            self.instrument = instrument
            self.voice = nil
        }
        
        /// Create a `Scope` that contains all `PerformanceContext` values with the given
        /// `Performer.Identifier`, `Instrument.Identifier`, and `Voice.Identifier` values.
        public init(
            _ performer: Performer.Identifier,
            _ instrument: Instrument.Identifier,
            _ voice: Voice.Identifier
        )
        {
            self.performer = performer
            self.instrument = instrument
            self.voice = voice
        }
        
        /// - returns: `true` if no `performer`, `instrument`, or `voice` attributes are 
        /// specified. Also `true` if the attributes specified here match with those of the
        /// given `context`. Otherwise, `false`.
        public func contains(_ context: PerformanceContext.Path) -> Bool {
            guard let performer = performer else { return true }
            guard performer == context.performer else { return false }
            guard let instrument = instrument else { return true }
            guard instrument == context.instrument else { return false }
            guard let voice = voice else { return true }
            return voice == context.voice
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

extension PerformanceContext.Path: Equatable {
    
    public static func == (lhs: PerformanceContext.Path, rhs: PerformanceContext.Path)
        -> Bool
    {
        return (
            lhs.performer == rhs.performer &&
            lhs.instrument == rhs.instrument &&
            lhs.voice == rhs.voice
        )
    }
}

extension PerformanceContext.Path: Hashable {
    
    public var hashValue: Int {
        return performer.hashValue ^ instrument.hashValue ^ voice.hashValue
    }
}
