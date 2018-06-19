//
//  RhythmTests.swift
//  RhythmTests
//
//  Created by James Bean on 6/18/18.
//

import XCTest
import MetricalDuration
import Rhythm

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

    func testLengthsAllTies() {
        let durations = 4/>8 * [1,1,1,1]
        let contexts = (0..<4).map { _ in MetricalContext<Int>.continuation }
        let rhythmTree = Rhythm(durations, contexts)
        XCTAssertEqual(lengths(of: [rhythmTree]), [4/>8])
    }

    func testLengthsTiesAndEvents() {

        let durations = 4/>8 * [1,1,1,1]

        let contexts: [MetricalContext<Int>] = [
            .continuation,
            .instance(.event(1)),
            .continuation,
            .instance(.event(1))
        ]

        let rhythmTree = Rhythm(durations, contexts)

        XCTAssertEqual(lengths(of: [rhythmTree]), [1/>8, 2/>8, 1/>8])
    }

    func testLengthsTiesEventsAndRests() {

        let durations = 4/>8 * [1,1,1,1]

        let contexts: [MetricalContext<Int>] = [
            .continuation,
            .instance(.event(1)),
            .continuation,
            .instance(.absence)
        ]

        let rhythmTree = Rhythm(durations, contexts)

        XCTAssertEqual(lengths(of: [rhythmTree]), [1/>8, 2/>8, 1/>8])
    }

    func testLengths() {

        let durations = 4/>8 * [1,2,1]

        // tie, rest, event
        let contexts: [MetricalContext<Int>] = [
            .continuation,
            .instance(.absence),
            .instance(.event(1))
        ]

        let rhythmTree = Rhythm(durations, contexts)

        // Create a sequence of rhythms:
        //
        //      tie, rest, event tie, rest, event tie, rest, event
        //
        let trees = (0..<3).map { _ in rhythmTree }

        XCTAssertEqual(lengths(of: trees), [1/>8, 2/>8, 2/>8, 2/>8, 2/>8, 2/>8, 1/>8])
    }
}
