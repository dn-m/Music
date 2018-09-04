//
//  RhythmTests.swift
//  RhythmTests
//
//  Created by James Bean on 6/18/18.
//

import XCTest
import Duration

class RhythmTests: XCTestCase {

    func testInitWithDurationAndValueTupleUsage() {
        let _ = Rhythm(3/>16, [
            (1, event({ print("play c natural") })),
            (2, event({ print("turn on the lights") })),
            (2, event({ print("make it go boom") })),
            (4, event({ print("make it stoppp") }))
        ])
    }

    func testInitWithDurationAndContextTupleUsage() {
        let _ = Rhythm(5/>32, [
            (1, event("ta")),
            (1, rest()),
            (1, event("di")),
            (1, tie()),
            (1, event("ti"))
        ])
    }

    func testInitWithDurationAndContextsUsage() {
        let _ = Rhythm(1/>4, [
            event("yup"),
            event("mhmm"),
            event("yeah"),
            event("ok"),
            event("fine"),
        ])
    }

    func testLengthsSingleAllTies() {
        let rhythm = Rhythm<Int>(4/>8, (0..<4).map { _ in tie() })
        XCTAssertEqual(rhythm.lengths, [4/>8])
    }

    func testLengthsSingleTiesAndEvents() {
        let rhythm = Rhythm<()>(4/>8, [tie(), event(()), tie(), event(())])
        XCTAssertEqual(rhythm.lengths, [1/>8, 2/>8, 1/>8])
    }

    func testLengthsSingleTiesEventsAndRests() {
        let rhythm = Rhythm(4/>8, [tie(), event(1), tie(), rest()])
        XCTAssertEqual(rhythm.lengths, [1/>8, 2/>8, 1/>8])
    }

    func testLengthsAllTies() {
        let rhythm = Rhythm<Int>(4/>8, (0..<4).map { _ in tie() })
        XCTAssertEqual(lengths(of: [rhythm]), [4/>8])
    }

    func testLengthsTiesAndEvents() {
        let rhythm = Rhythm<()>(4/>8, [tie(), event(()), tie(), event(())])
        XCTAssertEqual(lengths(of: [rhythm]), [1/>8, 2/>8, 1/>8])
    }

    func testLengthsTiesEventsAndRests() {
        let rhythm = Rhythm(4/>8, [tie(), event(1), tie(), rest()])
        XCTAssertEqual(lengths(of: [rhythm]), [1/>8, 2/>8, 1/>8])
    }

    func testLengths() {
        let rhythm = Rhythm(4/>8, [(1, tie()), (2, rest()), (1, event("uh"))])
        let rhythms = (0..<3).map { _ in rhythm }
        XCTAssertEqual(lengths(of: rhythms), [1/>8, 2/>8, 2/>8, 2/>8, 2/>8, 2/>8, 1/>8])
    }

    func testMapEvents() {
        let rhythm = Rhythm(4/>8, [tie(), event(1), tie(), rest(), event(2)])
        let mapped = rhythm.mapEvents([{ $0 * 2 }, { $0 * 4 }])
        let expected = Rhythm(4/>8, [tie(), event(2), tie(), rest(), event(8)])
        XCTAssertEqual(mapped, expected)
    }

    func testReplaceEvents() {
        let rhythm = Rhythm(4/>8, [tie(), event(1), tie(), rest(), event(2)])
        let mapped = rhythm.replaceEvents(["one","two"])
        let expected = Rhythm(4/>8, [tie(), event("one"), tie(), rest(), event("two")])
        XCTAssertEqual(mapped, expected)
    }

    func testDuratedEvents() {
        let rhythm = Rhythm(4/>8, [event(1), tie(), rest(), event(2)])
        let duratedEvents = rhythm.duratedEvents
        let durations = duratedEvents.map { $0.0 }
        let events = duratedEvents.map { $0.1 }
        XCTAssertEqual(durations, [2/>8, 1/>8])
        XCTAssertEqual(events, [1,2])
    }
}
