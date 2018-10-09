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
}
