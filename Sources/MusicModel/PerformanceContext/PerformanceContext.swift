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

extension PerformanceContext {

    /// The identifier for the given `performer`, if it exists in the `PerformanceContext`.
    /// Otherwise, `nil`.
    public func identifier(for performer: Performer) -> Performer.ID? {
        return performerByID[value: performer]
    }

    /// The performer for the given `identifier`, if it exists in the `PerformanceContext`.
    /// Otherwise, `nil`.
    public func performer(for identifier: Performer.ID) -> Performer? {
        return performerByID[key: identifier]
    }

    /// The identifier for the given `instrument`, if it exists in the `PerformanceContext`.
    /// Otherwise, `nil`.
    public func identifier(for instrument: Instrument) -> Instrument.ID? {
        return instrumentByID[value: instrument]
    }

    /// The instrument for the given `identifier`, if it exists in the `PerformanceContext`.
    /// Otherwise, `nil`.
    public func instrument(for identifier: Instrument.ID) -> Instrument? {
        return instrumentByID[key: identifier]
    }

    /// The identifier for the given `voice`, if it exists in the `PerformanceContext`.
    /// Otherwise, `nil`.
    public func identifier(for voice: Voice) -> Voice.ID? {
        return voiceByID[value: voice]
    }

    /// The voice for the given `identifier`, if it exists in the `PerformanceContext`.
    /// Otherwise, `nil`.
    public func voice(for identifier: Voice.ID) -> Voice? {
        return voiceByID[key: identifier]
    }
}

extension PerformanceContext: Equatable { }
extension PerformanceContext: Hashable { }

extension PerformanceContext {

    /// A filter for constraining a view onto a `PerformanceContext`.
    public struct Filter {

        let performers: Set<Performer>
        let instruments: Set<Instrument>
        let voices: Set<Voice>

        // MARK: - Initializers

        /// Creates a `PerformanceContext` showing the given sets of `performers`, `instruments`,
        /// and `voices`.
        ///
        /// If a given set is empty, all applicable values for the given type are included.
        init(
            performers: Set<Performer> = [],
            instruments: Set<Instrument> = [],
            voices: Set<Voice> = []
        )
        {
            self.performers = performers
            self.instruments = instruments
            self.voices = voices
        }
    }

    /// - Returns: A `PerformanceContext` filtered by the given `PerformanceContext.Filter`.
    public func filtered(by filter: Filter) -> PerformanceContext {
        // Exit early if there are no constraints
        if filter.performers.isEmpty && filter.instruments.isEmpty && filter.voices.isEmpty {
            return self
        }
        let filtered = performerInstrumentVoices.filter { piv in
            let pid = piv.performerInstrument.performer
            let iid = piv.performerInstrument.instrument
            let vid = piv.voice
            return (
                !filter.performers.isEmpty && filter.performers.contains(performer(for: pid)!) ||
                !filter.instruments.isEmpty && filter.instruments.contains(instrument(for: iid)!) ||
                !filter.voices.isEmpty && filter.voices.contains(voice(for: vid)!)
            )
        }
        return PerformanceContext(
            performerByID: performerByID.filter { id,_ in
                filtered.contains { $0.contains(performer: id) }
            },
            instrumentByID: instrumentByID.filter { id,_ in
                filtered.contains { $0.contains(instrument: id) }
            },
            voiceByID: voiceByID.filter { id,_ in filtered.contains { $0.voice == id } },
            performerInstrumentVoices: filtered
        )
    }
}

extension PerformanceContext {

    // MARK: - Builder

    /// A class which encapsulates the stateful construction of a `PerformanceContext`.
    public final class Builder {

        private var performerIdentifier = 0
        private var instrumentIdentifier = 0
        private var voiceIdentifier = 0

        var performers: Bimap<Performer.ID,Performer> = [:]
        var instruments: Bimap<Instrument.ID,Instrument> = [:]
        var voices: Bimap<Voice.ID,Voice> = [:]

        var voicesByPerformerInstrumentPair: [PerformerInstrument: Set<Voice.ID>] = [:]

        // MARK: - Initializers

        /// Creates an empty `PerformanceContext.Builder`.
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

    /// Adds the given `Performer` to the `PerformanceContext`.
    ///
    /// - Returns: The identifier for the given `performer`.
    @discardableResult
    public func addPerformer(_ performer: Performer) -> Performer.ID {
        guard let identifier = performers[value: performer] else {
            let identifier = makePerformerIdentifier()
            performers[key: identifier] = performer
            return identifier
        }
        return identifier
    }

    /// Adds the given `instrument` to the `PerformanceContext`.
    ///
    /// - Returns: The identifier for the given `instrument`.
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

    /// - Returns: A completed `PerformanceContext`.
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
