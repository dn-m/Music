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
}
