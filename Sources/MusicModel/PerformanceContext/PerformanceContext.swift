//
//  PerformanceContext.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import DataStructures

public struct PerformanceContext {

    // Storage of `Performer` by unique identifier.
    let performers: Bimap<Int,Performer>

    // Storage of `Instrument` by unique identifier.
    let instruments: Bimap<Int,Instrument>

    // Storage of unique voices for each `PerformerInstrumentPair`.
    let voices: [PerformerInstrumentPair: Set<Int>]
}

// Combination of a `Performer` and `Instrument`, stored by their integer identifiers.
struct PerformerInstrumentPair: Equatable, Hashable {
    let performer: Int
    let instrument: Int
}

extension PerformanceContext {

    // MARK: - Builder

    public final class Builder {

        private var performerIdentifier = 0
        private var instrumentIdentifier = 0

        var performers: Bimap<Int,Performer> = [:]
        var instruments: Bimap<Int,Instrument> = [:]
        var voices: [PerformerInstrumentPair: Set<Int>] = [:]
    }
}

extension PerformanceContext.Builder {

    // MARK: - Instance Methods

    public func addVoice(
        forPerformer performer: Performer,
        withInstrument instrument: Instrument,
        number: Int? = nil
    )
    {
        let performerID = addPerformer(performer)
        let instrumentID = addInstrument(instrument)
        let pair = PerformerInstrumentPair(performer: performerID, instrument: instrumentID)
        let number = number ?? voices[pair]?.count ?? 0
        voices.safelyInsert(number, forKey: pair)
    }

    public func addPerformer(_ performer: Performer) -> Int {
        guard let identifier = performers[value: performer] else {
            let identifier = makePerformerIdentifier()
            performers[key: identifier] = performer
            return identifier
        }
        return identifier
    }

    public func addInstrument(_ instrument: Instrument) -> Int {
        guard let identifier = instruments[value: instrument] else {
            let identifier = makeInstrumentIdentifier()
            instruments[key: identifier]  = instrument
            return identifier
        }
        return identifier
    }

    public func build() -> PerformanceContext {
        fatalError("TODO")
    }

    private func makePerformerIdentifier() -> Int {
        defer { performerIdentifier += 1 }
        return performerIdentifier
    }

    private func makeInstrumentIdentifier() -> Int {
        defer { instrumentIdentifier += 1}
        return instrumentIdentifier
    }
}

///// Description of the performing forces of a given `Entity`.
//public struct PerformanceContext {
    
//    /// Particular `Voice` -> `Instrument` -> `Performer` path within a `PerformanceContext`
//    /// hierarchy.
//    public struct Path: Equatable, Hashable {
//
//        /// `Performer.Identifier`
//        public let performer: Performer.Identifier
//
//        /// `Instrument.Identifier`
//        public let instrument: Instrument.Identifier
//
//        /// `Voice.Identifier`
//        public let voice: Voice.Identifier
//
//        /// Create a `Path` with identifiers of a `performer`, `instrument`, and `voice`.
//        public init(
//            _ performer: Performer.Identifier = "P",
//            _ instrument: Instrument.Identifier = "I",
//            _ voice: Voice.Identifier = 0
//        )
//        {
//            self.performer = performer
//            self.instrument = instrument
//            self.voice = voice
//        }
//    }
//
//    /// `Performer` of a given `PerformanceContext`.
//    public let performer: Performer
//
//    /// Create a `PerformanceContext` with a `Performer`
//    public init(_ performer: Performer = Performer()) {
//        self.performer = performer
//    }
//
//    /// - returns: `true` if this `PerformanceContext` contains the given `Path`.
//    public func contains(_ path: Path) -> Bool {
//        guard performer.identifier == path.performer else { return false }
//        guard let instrument = performer.instruments[path.instrument] else { return false }
//        return instrument.voices[path.voice] != nil
//    }

//    /// - returns: `true` if `self` is contained by a given `scope`.
//    public func isContained(by scope: Scope) -> Bool {
//        return scope.contains(self)
//    }
//}

//extension PerformanceContext: Equatable {
//
//    /// - returns: `true` if the `performer` values of each `PerformanceContext` are
//    /// equivalent.
//    public static func == (lhs: PerformanceContext, rhs: PerformanceContext) -> Bool {
//        return lhs.performer == rhs.performer
//    }
//}
//
