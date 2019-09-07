//
//  PitchClassTests.swift
//  Pitch
//
//  Created by James Bean on 5/7/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
import DataStructures
@testable import Pitch

class PitchClassTests: XCTestCase {

    let all: [Pitch.Class] = (0..<12).map(Pitch.Class.init)

    func testPitchClass() {
        let pitch = Pitch(60.0)
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

    // MARK: Group Axioms

    func testAssociativity() {
        zip(all,all,all).forEach {
            let left = ($0 + $1) + $2
            let right = $0 + ($1 + $2)
            XCTAssertEqual(left, right)
        }
    }

    func testIdentity() {
        all.forEach { XCTAssertEqual($0 + 0, $0) }
    }

    func testInverse() {
        all.forEach { XCTAssertEqual($0 + $0.inverse, 0) }
    }

    // MARK: Arithmetic

    func testAdd() {
        let a: Pitch.Class = 7
        let b: Pitch.Class = 8
        XCTAssertEqual(a + b, 3)
    }

    func testSubtract() {
        let a: Pitch.Class = 7
        let b: Pitch.Class = 8
        XCTAssertEqual(a - b, 11)
    }
}
