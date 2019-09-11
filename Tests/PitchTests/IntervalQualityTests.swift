//
//  IntervalQualityTests.swift
//  PitchTests
//
//  Created by James Bean on 10/10/18.
//

import XCTest
import Pitch

class IntervalQualityTests: XCTestCase {

    func testInverseDimAug() {
        let dim = DiatonicIntervalQuality.extended(.init(.single, .diminished))
        let aug = DiatonicIntervalQuality.extended(.init(.single, .augmented))
        XCTAssertEqual(dim.inverse, aug)
        XCTAssertEqual(aug.inverse, dim)
    }

    func testInverseMinorMajor() {
        let maj = DiatonicIntervalQuality.imperfect(.major)
        let min = DiatonicIntervalQuality.imperfect(.minor)
        XCTAssertEqual(maj.inverse, min)
        XCTAssertEqual(min.inverse, maj)
    }

    func testInversePerfect() {
        let perfect = DiatonicIntervalQuality.perfect(.perfect)
        XCTAssertEqual(perfect.inverse, perfect)
    }
}
