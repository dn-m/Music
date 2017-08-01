//
//  PitchClassTests.swift
//  Pitch
//
//  Created by James Bean on 5/7/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
import StructureWrapping
@testable import Pitch

class PitchClassTests: XCTestCase {

    func testPitchClass() {
        let pitch = Pitch(noteNumber: 60.0)
        XCTAssertEqual(pitch.class, 0.0)
    }
    
    func testPitchClassInitFloatLessThan12() {
        let _: Pitch.Class = 3.0
    }
    
    func testPitchClassInitFloatGreaterThan12() {
        let pc: Pitch.Class = 13.5
        XCTAssertEqual(pc, 1.5)
    }
    
    func testPitchClassInitIntLessThan12() {
        let _: Pitch.Class = 6
    }
    
    func testPitchClassInitIntGreaterThan12() {
        let pc: Pitch.Class = 15
        XCTAssertEqual(pc, 3)
    }
    
    func testPitchClassInitWithFloat() {
        let _: Pitch.Class = 15.0
    }
}
