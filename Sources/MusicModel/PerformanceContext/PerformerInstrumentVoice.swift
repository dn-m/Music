//
//  PerformerInstrumentVoice.swift
//  MusicModel
//
//  Created by James Bean on 9/12/18.
//

public struct PerformerInstrumentVoice {
    let performerInstrument: PerformerInstrument
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
