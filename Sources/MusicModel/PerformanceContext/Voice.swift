//
//  Voice.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import DataStructures

/// Model of a single `Voice` in a `PerformanceContext`.
public struct Voice {

    /// Performer identifier.
    let performer: PerformerID

    /// Instrument identifier.
    let instrument: InstrumentID
    
    /// Identifier.
    let identifier: Int
    
    /// Create a `Voice` with a given `identifier`.
    public init(performer: PerformerID, instrument: InstrumentID, _ identifier: Int) {
        self.performer = performer
        self.instrument = instrument
        self.identifier = identifier
    }
}

extension Voice {
    public func matches(performer: PerformerID, instrument: InstrumentID) -> Bool {
        return performer == self.performer && instrument == self.instrument
    }
}

extension Voice: Equatable { }
extension Voice: Hashable { }

public typealias VoiceID = Identifier<Voice>
