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

    func testAddEntity() {
        let identifier: AttributeID = 42
        let builder = Model.Builder()
        builder.addEntity(identifier, ofType: "\(type(of: 42))")
        XCTAssertEqual(builder.entitiesByType, ["Int": [identifier]])
    }

    func testCreateEvent() {
        let builder = Model.Builder()
        let identifier = builder.createEvent()
        XCTAssertEqual(builder.events, [identifier: []])
    }

    func testCreateEventInInterval() {
        let interval = Fraction(3,16) ..< Fraction(31,32)
        let builder = Model.Builder()
        let identifier = builder.createEvent(in: interval)
        XCTAssertEqual(builder.events, [identifier: []])
    }

    func testCreateEventWithEntities() {
        let entities: [AttributeID] = [0,1,2]
        let builder = Model.Builder()
        let identifier = builder.createEvent(with: entities)
        XCTAssertEqual(builder.events, [identifier: entities])
    }

    func testAddAttribute() {
        let builder = Model.Builder()
        let identifier = builder.add(5)
        XCTAssertEqual(builder.events, [:])
        XCTAssertEqual(builder.entitiesByType, ["\(type(of: 5))": [identifier]])
    }

    func testAddAttributeInInterval() {
        let interval = Fraction(3,16) ..< Fraction(31,32)
        let pitch: Pitch = 60
        let builder = Model.Builder()
        let identifier = builder.addEvent(with: [pitch], in: interval)
//        XCTAssertEqual(builder.entitiesByType, [ObjectIdentifier(Pitch.self): [identifier]])
//        XCTAssertEqual(builder.entitiesByInterval[interval]!, [identifier])
    }

    func testAddEventWithAttributes() {
        let attributes: [Any] = [Pitch(60), Articulation.staccato, Dynamic.f]
        let builder = Model.Builder()
        let (event,ids) = builder.addEvent(with: attributes)
        XCTAssertEqual(builder.entitiesByType["Pitch"]!, [ids[0]])
        XCTAssertEqual(builder.entitiesByType["Articulation"]!, [ids[1]])
        XCTAssertEqual(builder.entitiesByType["Dynamic"]!, [ids[2]])
        XCTAssertEqual(builder.events, [event: ids])
    }

    func testAddEventWithAttributesInInterval() {
        let interval = Fraction(3,16) ..< Fraction(31,32)
        let attributes: [Any] = [Pitch(72), Articulation.tenuto, Dynamic.ppp]
        let builder = Model.Builder()
        let (event,ids) = builder.addEvent(with: attributes, in: interval)
        XCTAssertEqual(builder.entitiesByType["Pitch"]!, [ids[0]])
        XCTAssertEqual(builder.entitiesByType["Articulation"]!, [ids[1]])
        XCTAssertEqual(builder.entitiesByType["Dynamic"]!, [ids[2]])
        XCTAssertEqual(builder.events, [event: ids])
    }

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
        let rhythm = Rhythm<[Any]>(1/>4, [event([pitch])])
        let builder = Model.Builder()
        let rhythmID = builder.addRhythm(rhythm, performedOn: instrument, by: performer)
        XCTAssertNotNil(builder.eventsByRhythm[rhythmID])
    }

    func testHelloWorld() {
        let performer = Performer(name: "Jordan")
        let instrument = Instrument(name: "Violin")
        let pitch: Pitch = 60
        let articulation: Articulation = .tenuto
        let dynamic: Dynamic = .fff
        let note = Rhythm<Event>(1/>1, [event([pitch, dynamic, articulation])])
        let meter = Meter(4,4)
        let tempo = Tempo(120, subdivision: 4)
        let builder = Model.Builder()
        builder.addMeter(meter)
        builder.addTempo(tempo)
        _ = builder.addRhythm(note, performedOn: instrument, by: performer)
        let _ = builder.build()
    }

    func testManyRhythms() {
        let performer = Performer(name: "Alexis")
        let instrument = Instrument(name: "Contrabass")
        let rhythms: [Rhythm<[Any]>] = (0..<10_000).map { _ in
            let amountEvents = 10
            let events: [Rhythm<[Any]>.Context] = (0..<amountEvents).map { _ in
                let amountPitches = 3
                let pitches: [Pitch] = (0..<amountPitches).map { _ in
                    return Pitch(Double.random(in: 48..<74))
                }
                return event(pitches)
            }
            let beats = Int.random(in: 1..<16)
            let duration = beats /> 4
            return Rhythm(duration,events)
        }
        let builder = Model.Builder()
        var offset: Fraction = .zero
        for rhythm in rhythms {
            _ = builder.addRhythm(rhythm, at: offset, performedOn: instrument, by: performer)
            offset += Fraction(rhythm.durationTree.duration)
        }
    }
}
