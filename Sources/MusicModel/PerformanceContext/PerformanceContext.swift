//
//  PerformanceContext.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import DataStructures

/// Context of a performing environment, in which there are any number of performers and
/// instruments. A performer can play one or more instruments, and an instrument can be played by
/// one or more performers.
public struct PerformanceContext {

    // MARK: - Instance Properties

    /// Storage of `Performer` by unique identifier.
    let performers: Bimap<PerformerID,Performer>

    /// Storage of `Instrument` by unique identifier.
    let instruments: Bimap<InstrumentID,Instrument>

    /// Storage of unique voices for each `PerformerInstrumentPair`.
    let voices: Bimap<VoiceID,Voice>

    // MARK: - Initializers

    /// Creates a `PerformanceContext` with the given `performers`, `instruments`, and `voices`.
    public init(
        performers: Bimap<PerformerID,Performer> = .init(),
        instruments: Bimap<InstrumentID,Instrument> = .init(),
        voices: Bimap<VoiceID,Voice> = .init()
    )
    {
        self.performers = performers
        self.instruments = instruments
        self.voices = voices
    }
}

// Combination of a `Performer` and `Instrument`, stored by their integer identifiers.
struct PerformerInstrumentPair {
    let performer: PerformerID
    let instrument: InstrumentID
    init(_ performer: PerformerID, _ instrument: InstrumentID) {
        self.performer = performer
        self.instrument = instrument
    }
}

extension PerformanceContext {

    struct Filter {
        let performer: PerformerID?
        let instrument: InstrumentID?
        let voice: Int?
        init(performer: PerformerID? = nil, instrument: InstrumentID? = nil) {
            self.performer = performer
            self.instrument = instrument
            self.voice = nil
        }
        init(performer: PerformerID, instrument: InstrumentID, voice: Int) {
            self.performer = performer
            self.instrument = instrument
            self.voice = voice
        }
    }
}

extension PerformerInstrumentPair: Equatable { }
extension PerformerInstrumentPair: Hashable { }

extension PerformanceContext {

    // MARK: - Builder

    public final class Builder {

        private var performerIdentifier = 0
        private var instrumentIdentifier = 0
        private var voiceIdentifier = 0

        var performers: Bimap<PerformerID,Performer> = [:]
        var instruments: Bimap<InstrumentID,Instrument> = [:]
        var voices: Bimap<VoiceID,Voice> = [:]

        var voicesByPerformerInstrumentPair: [PerformerInstrumentPair: Set<VoiceID>] = [:]

        // MARK: - Initializers

        /// Creates an empty `PerformanceContext`.
        public init() {
            self.performers = [:]
            self.instruments = [:]
            self.voices = [:]
            self.voicesByPerformerInstrumentPair = [:]
        }
    }
}

extension PerformanceContext.Builder {

    // MARK: - Instance Methods

    /// Adds a new voice for the given `performer` and `instrument`, with a given `number`, if the
    /// voices already exists. Otherwise, a new voice will be generated for the performer-instrument
    /// pair.
    public func addVoice(
        performer performer: Performer,
        instrument instrument: Instrument,
        number: Int? = nil
    ) -> VoiceID
    {
        let performerID = addPerformer(performer)
        let instrumentID = addInstrument(instrument)
        let pair = PerformerInstrumentPair(performerID, instrumentID)

        // If a number is known ahead of time, return the voice identifier if the voice is extant,
        // otherwise, add a new voice.
        if let number = number {
            let voice = Voice(performer: performerID, instrument: instrumentID, number)
            if let voiceID = voices[value: voice] { return voiceID }
            return addNewVoice(voice, with: pair)
        }

        // If the number is not known ahead of time, make a new voice for ther performer-instrument
        // pair.
        let voice = Voice(performer: performerID, instrument: instrumentID, makeNewVoiceID(pair))
        return addNewVoice(voice, with: pair)
    }

    func addNewVoice(_ voice: Voice, with pair: PerformerInstrumentPair) -> VoiceID {
        let identifier = makeVoiceIdentifier()
        voicesByPerformerInstrumentPair[pair, default: []].insert(identifier)
        voices[key: identifier] = voice
        return identifier
    }

    func makeNewVoiceID(_ pair: PerformerInstrumentPair) -> Int {
        return voicesByPerformerInstrumentPair[pair]?.count ?? 0
    }

    public func addPerformer(_ performer: Performer) -> PerformerID {
        guard let identifier = performers[value: performer] else {
            let identifier = makePerformerIdentifier()
            performers[key: identifier] = performer
            return identifier
        }
        return identifier
    }

    public func addInstrument(_ instrument: Instrument) -> InstrumentID {
        guard let identifier = instruments[value: instrument] else {
            let identifier = makeInstrumentIdentifier()
            instruments[key: identifier]  = instrument
            return identifier
        }
        return identifier
    }

    public func build() -> PerformanceContext {
        return PerformanceContext(performers: performers, instruments: instruments, voices: voices)
    }

    private func makeVoiceIdentifier() -> VoiceID {
        defer { voiceIdentifier += 1 }
        return Identifier(voiceIdentifier)
    }

    private func makePerformerIdentifier() -> Identifier<Performer> {
        defer { performerIdentifier += 1 }
        return Identifier(performerIdentifier)
    }

    private func makeInstrumentIdentifier() -> Identifier<Instrument> {
        defer { instrumentIdentifier += 1 }
        return Identifier(instrumentIdentifier)
    }
}
