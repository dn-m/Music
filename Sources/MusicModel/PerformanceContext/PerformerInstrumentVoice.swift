//
//  PerformerInstrumentVoice.swift
//  MusicModel
//
//  Created by James Bean on 9/12/18.
//

/// A triplet of identifiers for a `Performer`, `Instrument`, `Voice` composite.
public struct PerformerInstrumentVoice {

    /// The pair of identifiers for a `Performer`-`Instrument` aggregate.
    let performerInstrument: PerformerInstrument

    // The identifier for the `voice`.
    let voice: Voice.ID
}

extension PerformerInstrumentVoice {
    public func contains(performer: Performer.ID) -> Bool {
        return performerInstrument.contains(performer: performer)
    }
    public func contains(instrument: Instrument.ID) -> Bool {
        return performerInstrument.contains(instrument: instrument)
    }
}

extension PerformerInstrumentVoice: Equatable { }
extension PerformerInstrumentVoice: Hashable { }
