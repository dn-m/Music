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

    let performerInstrumentVoices: Set<PerformerInstrumentVoice>

    // MARK: - Initializers

    /// Creates a `PerformanceContext` with the given `performers`, `instruments`, and `voices`.
    init(
        performerByID: Bimap<Performer.ID,Performer>,
        instrumentByID: Bimap<Instrument.ID,Instrument>,
        voiceByID: Bimap<Voice.ID,Voice>,
        performerInstrumentVoices: Set<PerformerInstrumentVoice>
    )
    {
        self.performerByID = performerByID
        self.instrumentByID = instrumentByID
        self.voiceByID = voiceByID
        self.performerInstrumentVoices = performerInstrumentVoices
    }
}

extension PerformanceContext: Equatable { }

extension PerformanceContext {

    public struct Filter {
        let performers: Set<Performer.ID>
        let instruments: Set<Instrument.ID>
        let voices: Set<Voice.ID>
    }

    public func filtered(by filter: Filter) -> PerformanceContext {
        let performers = filter.performers.isEmpty ? Set(performerByID.keys) : filter.performers
        let instruments = filter.instruments.isEmpty ? Set(instrumentByID.keys) : filter.instruments
        let voices = filter.voices.isEmpty ? Set(voiceByID.keys) : filter.voices
        let p = self.performerByID.filter { performers.contains($0.key) }
        let i = self.instrumentByID.filter { instruments.contains($0.key) }
        let v = self.voiceByID.filter { voices.contains($0.key) }
        let pivs = performerInstrumentVoices.filter {
            p.keys.contains($0.performerInstrument.performer) ||
            i.keys.contains($0.performerInstrument.instrument) ||
            v.keys.contains($0.voice)
        }
        return PerformanceContext(
            performerByID: p,
            instrumentByID: i,
            voiceByID: v,
            performerInstrumentVoices: pivs
        )
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

    @discardableResult
    public func addPerformer(_ performer: Performer) -> Performer.ID {
        guard let identifier = performers[value: performer] else {
            let identifier = makePerformerIdentifier()
            performers[key: identifier] = performer
            return identifier
        }
        return identifier
    }

    @discardableResult
    public func addInstrument(_ instrument: Instrument) -> Instrument.ID {
        guard let identifier = instruments[value: instrument] else {
            let identifier = makeInstrumentIdentifier()
            instruments[key: identifier]  = instrument
            return identifier
        }
        return identifier
    }

    /// Adds a new voice for the given `performer` and `instrument`, with a given `number`, if the
    /// voices already exists. Otherwise, a new voice will be generated for the performer-instrument
    /// pair.
    @discardableResult
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
        let voice = Voice(
            name: "\(performer.name) - \(instrument.name) - \(makeNewVoiceID(performerInstrument))"
        )
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

    public func build() -> PerformanceContext {
        return PerformanceContext(
            performerByID: performers,
            instrumentByID: instruments,
            voiceByID: voices,
            performerInstrumentVoices: Set(
                voicesByPerformerInstrumentPair.lazy
                    .flatMap { performerInstrument,voices -> [PerformerInstrumentVoice] in
                        voices.map { voice in
                            PerformerInstrumentVoice(
                                performerInstrument: performerInstrument,
                                voice: voice
                            )
                        }
                    }
            )
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
