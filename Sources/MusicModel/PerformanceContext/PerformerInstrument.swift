//
//  PerformerInstrument.swift
//  MusicModel
//
//  Created by James Bean on 9/12/18.
//

// Combination of a `Performer` and `Instrument`, stored by their integer identifiers.
public struct PerformerInstrument {

    // MARK: - Instance Properties

    let performer: Performer.ID
    let instrument: Instrument.ID

    // MARK: - Initializers

    public init(_ performer: Performer.ID, _ instrument: Instrument.ID) {
        self.performer = performer
        self.instrument = instrument
    }
}

extension PerformerInstrument {
    public func contains(performer: Performer.ID) -> Bool {
        return self.performer == performer
    }
    public func contains(instrument: Instrument.ID) -> Bool {
        return self.instrument == instrument
    }
}

extension PerformerInstrument: Equatable { }
extension PerformerInstrument: Hashable { }
