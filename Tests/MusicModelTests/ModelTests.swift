//
//  ModelTests.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import XCTest
import DataStructures
import Math
import Pitch
import Articulations
import Duration
import Dynamics
@testable import MusicModel

class ModelTests: XCTestCase {

    // MARK: - Meter and Tempo

    func testAddMeter() {
        let builder = Model.Builder()
        builder.addMeter(Meter(3,4))
    }

    func testAddTempo() {
        let builder = Model.Builder()
        builder.addTempo(Tempo(60, subdivision: 4), at: Fraction(15,32), easing: .linear)
    }
  
    func testInferOffset() {
        let startTempo = Tempo(60, subdivision: 4)
        let endTempo = Tempo(120, subdivision: 4)
        let builder = Model.Builder()
            .addMeter(Meter(4,4))
            .addMeter(Meter(4,4))
            .addMeter(Meter(4,4))
            .addMeter(Meter(4,4))
            .addTempo(startTempo, easing: .linear)
            .addMeter(Meter(4,4))
            .addMeter(Meter(4,4))
            .addMeter(Meter(4,4))
            .addMeter(Meter(4,4))
            .addTempo(endTempo)
        let expectedInterp = Tempo.Interpolation(
            start: startTempo,
            end: endTempo,
            length: Fraction(16,4), easing: .linear
        )
        let expected: OrderedDictionary = [Fraction(16,4): expectedInterp]
        XCTAssertEqual(builder.tempoInterpolationCollectionBuilder.intermediate, expected)
    }

    func testSingleNoteRhythm() {
        let performer = Performer(name: "Eleven")
        let instrument = Instrument(name: "Upside Down")
        let pitch: Pitch = 60
        let rhythm = Rhythm<Event>(1/>4, [event(Event([pitch]))])
        let builder = Model.Builder()
        let voiceID = builder.createVoice(performer: performer, instrument: instrument)
        let rhythmID = builder.createRhythm(rhythm, voiceID: voiceID, offset: .zero)
        XCTAssertNotNil(builder.eventsByRhythm[rhythmID])
    }

    func testHelloWorld() {
        let performer = Performer(name: "Jordan")
        let instrument = Instrument(name: "Violin")
        let pitch: Pitch = 60
        let articulation: Articulation = .tenuto
        let dynamic: Dynamic = .fff
        let note = Rhythm<Event>(1/>1, [event(Event([pitch, dynamic, articulation]))])
        let meter = Meter(4,4)
        let tempo = Tempo(120, subdivision: 4)
        let builder = Model.Builder()
        builder.addMeter(meter)
        builder.addTempo(tempo)
        let voiceID = builder.createVoice(performer: performer, instrument: instrument)
        _ = builder.createRhythm(note, voiceID: voiceID, offset: .zero)
    }

    func testSlur() {
        let performer = Performer(name: "Leo")
        let instrument = Instrument(name: "Guitar")
        let pitch: Pitch = 60
        let articulation: Articulation = .tenuto
        let dynamic: Dynamic = .fff
        let slurStart: Slur = .start
        let slurStop: Slur = .stop
        let rhythm = Rhythm<Event>(1/>1, [
            event(Event([pitch, dynamic, articulation, slurStart])),
            event(Event([pitch, dynamic, articulation, slurStop]))
            ])
        let builder = Model.Builder()
        let voiceID = builder.createVoice(performer: performer, instrument: instrument)
        let _ = builder.createRhythm(rhythm, voiceID: voiceID, offset: .zero)
    }

    func testManyRhythms() {
        let performer = Performer(name: "Alexis")
        let instrument = Instrument(name: "Contrabass")
        let rhythms: [Rhythm<Event>] = (0..<1_000).map { _ in
            let amountEvents = 10
            let events: [Rhythm<Event>.Context] = (0..<amountEvents).map { _ in
                let amountPitches = 3
                let pitches: [Pitch] = (0..<amountPitches).map { _ in
                    return Pitch(Double.random(in: 48..<74))
                }
                let articulation = Articulation.staccato
                let dynamic = Dynamic.fff
                let attributes = Event(pitches + [articulation] + [dynamic])
                return event(attributes)
            }
            let beats = Int.random(in: 1..<16)
            let duration = beats /> 4
            return Rhythm(duration,events)
        }
        let builder = Model.Builder()
        var offset: Fraction = .zero
        let voiceID = builder.createVoice(performer: performer, instrument: instrument)
        for rhythm in rhythms {
            _ = builder.createRhythm(rhythm, voiceID: voiceID, offset: offset)
            offset += Fraction(rhythm.durationTree.duration)
        }
        let _ = builder.build()
    }

    func testFilterPerformanceContext() {
        let model = Model(
            performanceContext: jackQuartet,
            tempi: .empty,
            meters: .empty,
            attributeByID: [:],
            events: [:],
            attributesByEvent: [:],
            rhythms: [:],
            eventsByRhythm: [:]
        )
        let performanceContextFilter = PerformanceContext.Filter(
            performers: [jay],
            instruments: [viola],
            voices: [chrisVoice1]
        )
        let filter = Model.Filter(
            interval: nil,
            performanceContext: performanceContextFilter,
            types: []
        )
        let result = model.fragment(filter: filter)
        let expectedPerformanceContext = PerformanceContext(
            performerByID: [0: john, 2: chris, 3: jay],
            instrumentByID: [0: violinI, 2: viola, 3: violoncello],
            voiceByID: [1: chrisVoice1, 4: johnVoice0, 5: jayVoice0],
            performerInstrumentVoices: [
                .init(performerInstrument: PerformerInstrument(2,0), voice: 1),
                .init(performerInstrument: PerformerInstrument(0,2), voice: 4),
                .init(performerInstrument: PerformerInstrument(3,3), voice: 5),
            ]
        )
        let expected = Model.Fragment(
            performanceContext: expectedPerformanceContext,
            tempoFragments: .empty,
            meterFragments: .empty,
            attributesByID: [:],
            events: [:],
            attributesByEvent: [:],
            rhythms: [:],
            eventsByRhythm: [:]
        )
        XCTAssertEqual(result.performanceContext, expected.performanceContext)
    }
}
