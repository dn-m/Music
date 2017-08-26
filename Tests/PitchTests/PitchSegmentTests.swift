//
//  PitchSegmentTests.swift
//  PitchTests
//
//  Created by James Bean on 8/24/17.
//

import XCTest
import Pitch

class PitchSegmentTests: XCTestCase {

    func testNormalFormSinglePitch() {
        let pcs: [Pitch.Class] = [0]
        XCTAssertEqual(pcs.normalForm, [0])
    }

    func testNormalFormWrapping() {
        let pcs: [Pitch.Class] = [8,0,4,6]
        XCTAssertEqual(pcs.normalForm, [4,6,8,0])
    }

    func testPrimeForm() {
        let pcs: [Pitch.Class] = [8,0,4,6]
        XCTAssertEqual(pcs.primeForm, [0,2,4,8])
    }

    func testPrimeFormsEqual() {
        let a: [Pitch.Class] = [11,2,3]
        let b: [Pitch.Class] = [11,7,10]
        XCTAssertEqual(a.primeForm, b.primeForm)
        XCTAssertEqual(a.primeForm, [0,1,4])
    }
}
