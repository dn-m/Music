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
        let identifier = UUID()
        let builder = Model.Builder()
        builder.addEntity(identifier, ofType: "ID")
        XCTAssertEqual(builder.entitiesByType, ["ID": [identifier]])
    }

    func testCreateEvent() {
        let builder = Model.Builder()
        let identifier = builder.createEvent()
        XCTAssertEqual(builder.events, [identifier: []])
        XCTAssertEqual(builder.entitiesByType, ["EventContainer": [identifier]])
    }

    func testCreateEventInInterval() {
        let interval = Fraction(3,16) ..< Fraction(31,32)
        let builder = Model.Builder()
        let identifier = builder.createEvent(in: interval)
        XCTAssertEqual(builder.events, [identifier: []])
        XCTAssertEqual(builder.entitiesByType, ["EventContainer": [identifier]])
        XCTAssertEqual(builder.entitiesByInterval[interval]!, [identifier])
    }

    func testCreateEventWithEntities() {
        let entities = Set((0..<3).map { _ in UUID() })
        let builder = Model.Builder()
        let identifier = builder.createEvent(with: entities)
        XCTAssertEqual(builder.events, [identifier: entities])
        XCTAssertEqual(builder.entitiesByType, ["EventContainer": [identifier]])
    }

    func testAddAttribute() {
        let builder = Model.Builder()
        let identifier = builder.add(5)
        XCTAssertEqual(builder.events, [:])
        XCTAssertEqual(builder.entitiesByType, ["Int": [identifier]])
    }

    func testAddAttributeInInterval() {
        let interval = Fraction(3,16) ..< Fraction(31,32)
        let pitch: Pitch = 60
        let builder = Model.Builder()
        let identifier = builder.add(pitch, in: interval)
        XCTAssertEqual(builder.entitiesByType, ["Pitch": [identifier]])
        XCTAssertEqual(builder.entitiesByInterval[interval]!, [identifier])
    }

    func testAddEventWithAttributes() {
        let attributes: [Any] = [Pitch(60), Articulation.staccato, Dynamic.f]
        let builder = Model.Builder()
        let (event,ids) = builder.addEvent(with: attributes)
        XCTAssertEqual(builder.entitiesByType["Pitch"]!, [ids[0]])
        XCTAssertEqual(builder.entitiesByType["Articulation"]!, [ids[1]])
        XCTAssertEqual(builder.entitiesByType["Dynamic"]!, [ids[2]])
        XCTAssertEqual(builder.events, [event: Set(ids)])
    }

    func testAddEventWithAttributesInInterval() {
        let interval = Fraction(3,16) ..< Fraction(31,32)
        let attributes: [Any] = [Pitch(72), Articulation.tenuto, Dynamic.ppp]
        let builder = Model.Builder()
        let (event,ids) = builder.addEvent(with: attributes, in: interval)
        XCTAssertEqual(builder.entitiesByType["Pitch"]!, [ids[0]])
        XCTAssertEqual(builder.entitiesByType["Articulation"]!, [ids[1]])
        XCTAssertEqual(builder.entitiesByType["Dynamic"]!, [ids[2]])
        XCTAssertEqual(builder.events, [event: Set(ids)])
        XCTAssertEqual(builder.entitiesByInterval[interval]!, Set(ids + [event]))
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
        let pitch: Pitch = 60
        let rhythm = Rhythm<[Any]>(1/>4, [event([pitch])])
        let builder = Model.Builder()
        let rhythmID = builder.addRhythm(rhythm)
        XCTAssertNotNil(builder.eventsByRhythm[rhythmID])
        XCTAssertNotNil(builder.attributes[rhythmID] as? Rhythm<[Any]>)
    }

    func testManyRhythms() {

        let rhythms: [Rhythm<[Any]>] = (0..<1000).map { _ in
            let amountEvents = Int.random(in: 1..<16)
            let events: [Rhythm<[Any]>.Leaf] = (0..<amountEvents).map { _ in
                let amountPitches = Int.random(in: 1..<16)
                let pitches: [Pitch] = (0..<amountPitches).map { _ in
                    let nn = Double.random(in: 48..<74)
                    return Pitch(nn)
                }
                return event(pitches)
            }
            let beats = Int.random(in: 1..<16)
            let duration = beats /> 4
            return Rhythm(duration,events)
        }

        let builder = Model.Builder()
        for rhythm in rhythms {
            builder.addRhythm(rhythm)
        }
    }
}
