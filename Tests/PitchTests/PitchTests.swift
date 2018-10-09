//
//  PitchTests.swift
//  Pitch
//
//  Created by James Bean on 3/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
import Algebra
@testable import Pitch

class PitchTests: XCTestCase {
    
    func testInit() {
        let _: Pitch = 60
        let _: Pitch = 60.0
    }

    func testPitchPlusFloat() {
        let pitch = Pitch(60.0)
        let sum = pitch + 10.0
        XCTAssertEqual(sum, 70.0)
    }

    func testFloatPlusPitch() {
        let pitch: Pitch = Pitch(60.0)
        let sum = 10.0 + pitch
        XCTAssertEqual(sum, 70.0)
    }
    
    func testPitchMinusFloat() {
        let pitch = Pitch(60.0)
        let sum = pitch - 10.0
        XCTAssertEqual(sum, 50.0)
    }
    
    func testFloatMinusPitch() {
        let pitch = Pitch(10.0)
        let sum = 60.0 - pitch
        XCTAssertEqual(sum, 50.0)
    }

    func testPitchAdditiveMonoid() {
        let intervals: [Pitch] = [2,1,2,2,1,2]
        let distances = intervals.accumulatingSum
        let expected: [Pitch] = [0,2,3,5,7,8]
        XCTAssertEqual(expected, distances)
    }
}
