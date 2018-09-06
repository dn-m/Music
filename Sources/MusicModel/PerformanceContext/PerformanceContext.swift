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
    let voices: [PerformerInstrumentPair: Set<VoiceID>]

    // MARK: - Initializers

    /// Creates a `PerformanceContext` with the given `performers`, `instruments`, and `voices`.
    public init(
        performers: Bimap<PerformerID,Performer> = .init(),
        instruments: Bimap<InstrumentID,Instrument> = .init(),
        voices: [PerformerInstrumentPair: Set<VoiceID>] = [:]
    )
    {
        self.performers = Bimap()
        self.instruments = Bimap()
        self.voices = [:]
    }
}

// Combination of a `Performer` and `Instrument`, stored by their integer identifiers.
public struct PerformerInstrumentPair: Equatable, Hashable {
    public let performer: PerformerID
    public let instrument: InstrumentID
}

extension PerformanceContext {

    // MARK: - Builder

    public final class Builder {

        private var performerIdentifier = 0
        private var instrumentIdentifier = 0

        var performers: Bimap<PerformerID,Performer> = [:]
        var instruments: Bimap<InstrumentID,Instrument> = [:]
        var voices: [PerformerInstrumentPair: Set<VoiceID>] = [:]

        // MARK: - Initializers

        /// Creates an empty `PerformanceContext`.
        public init() {
            self.performers = [:]
            self.instruments = [:]
            self.voices = [:]
        }
    }
}

extension PerformanceContext.Builder {

    // MARK: - Instance Methods

    /// Adds a new voice for the given `performer` and `instrument`, with a given `number`, if the
    /// voices already exists. Otherwise, a new voice will be generated for the performer-instrument
    /// pair.
    public func addVoice(
        forPerformer performer: Performer,
        withInstrument instrument: Instrument,
        number: Int? = nil
    ) -> VoiceID
    {
        let performerID = addPerformer(performer)
        let instrumentID = addInstrument(instrument)
        let pair = PerformerInstrumentPair(performer: performerID, instrument: instrumentID)
        let identifier = VoiceID(number ?? voices[pair]?.count ?? 0)
        voices.safelyInsert(identifier, forKey: pair)
        return identifier
    }

    public func addPerformer(_ performer: Performer) -> Identifier<Performer> {
        guard let identifier = performers[value: performer] else {
            let identifier = makePerformerIdentifier()
            performers[key: identifier] = performer
            return identifier
        }
        return identifier
    }

    public func addInstrument(_ instrument: Instrument) -> Identifier<Instrument> {
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

    private func makePerformerIdentifier() -> Identifier<Performer> {
        defer { performerIdentifier += 1 }
        return Identifier(performerIdentifier)
    }

    private func makeInstrumentIdentifier() -> Identifier<Instrument> {
        defer { instrumentIdentifier += 1 }
        return Identifier(instrumentIdentifier)
    }
}
