//
//  PitchTests.swift
//  Pitch
//
//  Created by James Bean on 3/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import Pitch

class PitchTests: XCTestCase {
    
    func testRandom() {
        let pitch: Pitch = Pitch.random()
        XCTAssert(pitch.noteNumber.value >= 60 && pitch.noteNumber.value <= 72)
    }
    
    func testInit() {
        let _ = Pitch(frequency: 440)
        let _: Pitch = 60
        let _: Pitch = 60.0
    }
    
    func testInitWithPitch() {
        let original = Pitch(noteNumber: 60.0)
        let new = Pitch(original)
        XCTAssertEqual(original, new)
    }
    
    func testPrintDescription() {
        let pitch = Pitch(60.0)
        XCTAssertEqual(pitch.description, "60.0")
    }
    
    func testPitchPlusFloat() {
        let pitch = Pitch(60.0)
        let sum = pitch + 10.0
        XCTAssertEqual(sum, 70.0)
    }
    
    func testFloatPlusPitch() {
        let pitch = Pitch(60.0)
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

}
