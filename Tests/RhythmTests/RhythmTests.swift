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

    func testInitUsage() {
        let _ = Rhythm(3/>16, [
            (1, { print("play c natural") }),
            (2, { print("turn on the lights") }),
            (2, { print("make it go boom") }),
            (4, { print("make it stoppp") })
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
