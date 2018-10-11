//
//  ScaleTests.swift
//  PitchTests
//
//  Created by James Bean on 10/9/18.
//

import XCTest
@testable import Pitch

class ScaleTests: XCTestCase {

    func testInitAPI() {
        let initWithFirstAndIntervals = Scale(60, [2,1,2,1,2,1,2,1])
        let initWithPitches: Scale = [60,62,63,65,66,68,69,71,72]
        XCTAssertEqual(initWithFirstAndIntervals, initWithPitches)
    }

    func testMajor() {
        let _ = Scale(60, .major)
    }

    func testMelodicMinor() {
        let _ = Scale(66, .melodicMinorAscending)
        let _ = Scale(66, .melodicMinorDescending)
    }

    func testScaleDegreeNil() {
        let cMajor = Scale(60, .major)
        let pitches: [Pitch] = [61,63,66,68,70]
        for pitch in pitches {
            XCTAssertNil(cMajor.scaleDegree(pitch: pitch))
        }
    }

    func testScaleDegreeNotNil() {
        let cMajor = Scale(60, .major)
        let pitches: [Pitch] = [60,62,64,65,67,69,71]
        for pitch in pitches {
            XCTAssertNotNil(cMajor.scaleDegree(pitch: pitch))
        }
    }

    func testScaleDegree() {
        let cMinor = Scale(60, .minor)
        XCTAssertEqual(cMinor.scaleDegree(pitch: 63), 3)
    }

    func testPitchFromScaleDegreeNotNil() {
        let cMinor = Scale(60, .minor)
        let scaleDegrees = [1,2,3,4,5,6,7]
        for scaleDegree in scaleDegrees {
            XCTAssertNotNil(cMinor.pitch(scaleDegree: scaleDegree))
        }
    }

    func testPitchFromScaleDegree0() {
        let eMajor = Scale(64, .major)
        XCTAssertEqual(eMajor.pitch(scaleDegree: 1), 64)
    }

    func testPitchFromScaleDegree3() {
        let eMajor = Scale(64, .major)
        XCTAssertEqual(eMajor.pitch(scaleDegree: 3), 68)
    }

    func testPitchFromScaleDegree9() {
        let eMajor = Scale(64, .major)
        XCTAssertEqual(eMajor.pitch(scaleDegree: 9), 78)
    }

    func testScaleSequenceLooping() {
        let root: Pitch = 0
        let intervals = Scale.IntervalPattern(intervals: [2,2,1,2,2,2,1], isLooping: true)
        let scale = Scale(root,intervals)
        let _ = Array(scale.prefix(100))
    }
}
