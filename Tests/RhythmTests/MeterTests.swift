//
//  MeterTests.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import XCTest
import Rhythm

class MeterTests: XCTestCase {

    func testTempoInit() {
        _ = Tempo(78, subdivision: 4)
    }

    func testTempoDurationAt60() {
        let tempo = Tempo(60)
        XCTAssertEqual(tempo.durationOfBeat, 1)
    }

    func testTempoDurationAt90() {
        let tempo = Tempo(90)
        XCTAssertEqual(tempo.durationOfBeat, (2/3))
    }

    func testTempoDurationAt30() {
        let tempo = Tempo(30)
        XCTAssertEqual(tempo.durationOfBeat, 2)
    }

    func testTempoDurationForBeatAtSubdivisionLevelSameAt60() {
        let tempo = Tempo(60, subdivision: 4)
        XCTAssertEqual(tempo.duration(forBeatAt: 4), 1)
    }

    func testTempoDurationForBeatAtSubdivisionLevelDoubleAt60() {
        let tempo = Tempo(60, subdivision: 4)
        XCTAssertEqual(tempo.duration(forBeatAt: 8), 0.5)
    }

    func testTempoDurationForBeatAtSubdivisionLevelHalfAt90() {
        let tempo = Tempo(90, subdivision: 8)
        XCTAssertEqual(tempo.duration(forBeatAt: 4), (2/3) * 2)
    }

    func testMeterBeatOffsets() {
        let meter = Meter(7,16)
        XCTAssertEqual(meter.beatOffsets, (0..<7).map { beat in beat/>16 })
    }
}
