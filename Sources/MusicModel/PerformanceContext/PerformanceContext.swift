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

    let performerByID: Bimap<Performer.ID,Performer>
    let instrumentByID: Bimap<Instrument.ID,Instrument>
    let voiceByID: Bimap<Voice.ID,Voice>

    let performerInstrumentVoices: [PerformerInstrumentVoice]

    // MARK: - Initializers

    /// Creates a `PerformanceContext` with the given `performers`, `instruments`, and `voices`.
    init(
        performerByID: Bimap<Performer.ID,Performer>,
        instrumentByID: Bimap<Instrument.ID,Instrument>,
        voiceByID: Bimap<Voice.ID,Voice>,
        performerInstrumentVoices: [PerformerInstrumentVoice]
    )
    {
        self.performerByID = performerByID
        self.instrumentByID = instrumentByID
        self.voiceByID = voiceByID
        self.performerInstrumentVoices = performerInstrumentVoices
    }
}

extension PerformanceContext {

    struct Filter {
        let performers: [Performer.ID]
        let instruments: [Instrument.ID]
        let voices: [Voice]

        // TODO
    }
}

extension PerformanceContext {

    // MARK: - Builder

    public final class Builder {

        private var performerIdentifier = 0
        private var instrumentIdentifier = 0
        private var voiceIdentifier = 0

        var performers: Bimap<Performer.ID,Performer> = [:]
        var instruments: Bimap<Instrument.ID,Instrument> = [:]
        var voices: Bimap<Voice.ID,Voice> = [:]

        var voicesByPerformerInstrumentPair: [PerformerInstrument: Set<Voice.ID>] = [:]

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
    public func addVoice(_ voice: Voice? = nil, performer: Performer, instrument: Instrument) ->
        Voice.ID
    {
        let performerID = addPerformer(performer)
        let instrumentID = addInstrument(instrument)
        let performerInstrument = PerformerInstrument(performerID, instrumentID)
        // If a voice is known ahead of time, return the voice identifier if the voice is extant,
        // otherwise, add a new voice and return an identifier.
        if let voice = voice {
            if let voiceID = voices[value: voice] { return voiceID }
            return addNewVoice(voice, with: performerInstrument)
        }
        // If the number is not known ahead of time, make a new voice for ther performer-instrument
        // pair.
        let voice = Voice(name: "\(makeNewVoiceID(performerInstrument))")
        return addNewVoice(voice, with: performerInstrument)
    }

    func addNewVoice(_ voice: Voice, with pair: PerformerInstrument) -> Voice.ID {
        let identifier = makeVoiceIdentifier()
        voicesByPerformerInstrumentPair[pair, default: []].insert(identifier)
        voices[key: identifier] = voice
        return identifier
    }

    func makeNewVoiceID(_ pair: PerformerInstrument) -> Int {
        return voicesByPerformerInstrumentPair[pair]?.count ?? 0
    }

    public func addPerformer(_ performer: Performer) -> Performer.ID {
        guard let identifier = performers[value: performer] else {
            let identifier = makePerformerIdentifier()
            performers[key: identifier] = performer
            return identifier
        }
        return identifier
    }

    public func addInstrument(_ instrument: Instrument) -> Instrument.ID {
        guard let identifier = instruments[value: instrument] else {
            let identifier = makeInstrumentIdentifier()
            instruments[key: identifier]  = instrument
            return identifier
        }
        return identifier
    }

    public func build() -> PerformanceContext {
        var performerInstrumentVoices: [PerformerInstrumentVoice] = []
        for (pi,vs) in voicesByPerformerInstrumentPair {
            for v in vs {
                performerInstrumentVoices.append(PerformerInstrumentVoice(performerInstrument: pi, voice: v))
            }
        }
        return PerformanceContext(
            performerByID: performers,
            instrumentByID: instruments,
            voiceByID: voices,
            performerInstrumentVoices: performerInstrumentVoices
        )
    }

    private func makeVoiceIdentifier() -> Voice.ID {
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
