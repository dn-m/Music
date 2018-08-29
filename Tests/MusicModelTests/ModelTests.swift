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
        XCTAssert(!builder.entitiesByType["Pitch"]!.intersection(ids).isEmpty)
        XCTAssert(!builder.entitiesByType["Articulation"]!.intersection(ids).isEmpty)
        XCTAssert(!builder.entitiesByType["Dynamic"]!.intersection(ids).isEmpty)
        XCTAssertEqual(builder.events, [event: ids])
    }

    func testAddEventWithAttributesInInterval() {
        let interval = Fraction(3,16) ..< Fraction(31,32)
        let attributes: [Any] = [Pitch(72), Articulation.tenuto, Dynamic.ppp]
        let builder = Model.Builder()
        let (event,ids) = builder.addEvent(with: attributes, in: interval)
        XCTAssert(!builder.entitiesByType["Pitch"]!.intersection(ids).isEmpty)
        XCTAssert(!builder.entitiesByType["Articulation"]!.intersection(ids).isEmpty)
        XCTAssert(!builder.entitiesByType["Dynamic"]!.intersection(ids).isEmpty)
        XCTAssertEqual(builder.events, [event: ids])
        XCTAssertEqual(builder.entitiesByInterval[interval]!, event + ids)
    }

    func testEroicaHit() {
        let pitches: [Pitch] = [39,46,51,55,67,70,75,79]
        let articulation: Articulation = .staccato
        let dynamic: Dynamic = .f

    }

//    func testHappyBirthday() {
//        let pitches: [Pitch] = [
//            67,67,69,67,72,71,
//            67,67,69,67,74,72,
//            67,67,79,76,74,72,71,
//            77,77,76,72,74,72
//        ]
//        let lyrics: [String] = [
//            "Hap","py","birth","day","to","you",
//            "Hap","py","birth","day","to","you",
//            "Hap","py","birth","day","dear","some","one",
//            "Hap","py","birth","day","to","you"
//        ]
//
//        // Create rhythms containing void for now, then map them with the pitches and
//        let happy = Rhythm(1/>4, [(3,event(())),(1,event(()))])
//        let birth = Rhythm(1/>4, event(()))
//        let day = Rhythm(1/>4, event(()))
//        let to = Rhythm(1/>4, event(()))
//        let you = Rhythm(1/>2, event(()))
//        let dear = Rhythm(1/>4, event(()))
//        let some = Rhythm(1/>4, event(()))
//        let one = Rhythm(1/>4, event(()))
//
//
//        let happyPitches = happy.mapLeaves { _ in [67,67] }
//    }

//    func testAddPitchArrayAttribute() {
//        let pitches: Set<Pitch> = [60,61,62]
//        let interval = Fraction(4,8)...Fraction(5,8)
//        let model = Model.Builder()
//            .add(pitches, label: "pitch", with: PerformanceContext.Path(), in: interval)
//            .build()
//        #warning("Add assertion to testAddPitchArrayAttribute()")
//    }
//
//    func testPitchesAndAtriculations() {
//        let intervals = (0..<2).map { offset in Fraction(offset, 8)...Fraction(offset + 1, 8) }
//        let pitches: [Pitch] = [60,61,62]
//        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
//        let articulations: [Articulation] = [.staccato, .accent, .tenuto]
//        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
//        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
//        let builder = Model.Builder()
//        zip(events, intervals).forEach { event, interval in builder.add(event, in: interval) }
//        let model = builder.build()
//        print(model)
//        #warning("Add assertion to testPitchesAndAtriculations()")
//    }
//
//    func testAddRhythm() {
//
//        let rhythm = Rhythm<Int>(
//            3/>16 * [1,2,3,1],
//            [
//                .instance(.event(0)),
//                .instance(.event(0)),
//                .instance(.event(0)),
//                .instance(.event(0))
//            ]
//        )
//
//        let pitches: [Pitch] = [60,61,62,63]
//        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
//        let articulations: [Articulation] = [.staccato, .accent, .tenuto, .accent]
//        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
//        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
//
//        let model = Model.Builder()
//            .add(rhythm, at: 0, with: events)
//            .build()
//        print(model)
//
//        for rhythm in model.rhythms {
//            print("RHYTHM:")
//            for event in rhythm.events {
//                let attributeIDs = model.events[event]!
//                print(attributeIDs.map { model.values[$0] })
//            }
//        }
//
//        #warning("Add assertion to testAddRhythm()")
//    }
//
//    func testAddManyRhythms() {
//
//        let rhythm = Rhythm<Int>(
//            1/>4 * [1,2,3,1],
//            [
//                .instance(.event(0)),
//                .instance(.event(0)),
//                .instance(.event(0)),
//                .instance(.event(0))
//            ]
//        )
//
//        let pitches: [Pitch] = [60,61,62,63]
//        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
//        let articulations: [Articulation] = [.staccato, .accent, .tenuto, .accent]
//        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
//        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
//
//        let builder = Model.Builder()
//        (0..<100).forEach { offsetBeats in
//            builder.add(rhythm, at: Fraction(offsetBeats,4), with: events)
//        }
//
//        let model = builder.build()
//        print(model)
//
//        #warning("Add assertion to testAddManyRhythms()")
//    }
//
//    func testFilter() {
//
//        let rhythm = Rhythm<Int>(
//            1/>4 * [1,1,1,1],
//            [
//                .instance(.event(0)),
//                .instance(.event(0)),
//                .instance(.event(0)),
//                .instance(.event(0))
//            ]
//        )
//
//        let context1 = PerformanceContext.Path("P", "I", 0)
//        let context2 = PerformanceContext.Path("P", "II", 3)
//        let pitches: [Pitch] = [60,61,62,63]
//        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
//        let articulations: [Articulation] = [.staccato, .accent, .tenuto, .accent]
//        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
//        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
//
//        let builder = Model.Builder()
//
//        // Add a bunch of rhythms
//        (0..<1000).forEach { offsetBeats in
//            builder.add(rhythm, at: Fraction(offsetBeats,4), with: events, and: context1)
//            builder.add(rhythm, at: Fraction(offsetBeats,4), with: events, and: context2)
//        }
//
//        // Construct the model
//        let model = builder.build()
//
//        let interval = Model.Filter(interval: Fraction(4,4)...Fraction(5/>4))
//        let scope = Model.Filter(scope: PerformanceContext.Scope("P","I"))
//        let label = Model.Filter(label: "articulation")
//        let filter = [interval,scope,label].nonEmptyProduct!
//
//        // Get the ids of all of the attributes within the given filter
//        let filteredIDs = filter.apply(model)
//
//        filteredIDs.forEach { id in
//            let value = model.values[id]!
//            let interval = model.intervals[id]!
//            let context = model.performanceContexts[id]!
//            print("\(value); interval: \(interval); contexts: \(context)")
//        }
//
//        #warning("Add assertion to testFilter()")
//    }
//
//
//    func testAddMeterStructure() {
//
//        let builder = Model.Builder()
//
//
//        let meters: [Meter] = (0..<1_000_000).map { _ in
//            let randomBeats = Int.random(in: 1..<11)
//            let randomSubdivision = 8
//            return Meter(randomBeats, randomSubdivision)
//        }
//
//        for meter in meters {
//            builder.add(meter)
//        }
//
////        builder.add(Tempo(90), at: .zero)
////        builder.add(Tempo(60), at: Fraction(4,4), easing: .linear)
////        builder.add(Tempo(120), at: Fraction(24,4))
//
//        let model = builder.build()
//        print(model)
//        // TODO: Assert something!
//
//        #warning("Add assertion to testAddMeterStructure()")
//    }
}
