//
//  ChordTests.swift
//  PitchTests
//
//  Created by James Bean on 10/9/18.
//

import XCTest
@testable import Pitch

class ChordTests: XCTestCase {

    func testInitAPI() {
        let initWithFirstAndIntervals = Chord(60, [4,3])
        let initWithPitches: Chord = [60,64,67]
        XCTAssertEqual(initWithFirstAndIntervals, initWithPitches)
    }

    func testIntervalPattern() {
        let _: Chord.IntervalPattern = [4,3]
    }

    func testCMajor() {
        let _ = Chord(60, .major)
    }

    func testFSharpMinor() {
        let _ = Chord(66, .minor)
    }
}
