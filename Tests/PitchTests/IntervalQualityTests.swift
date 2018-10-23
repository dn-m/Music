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
        let dim = IntervalQuality.extended(.init(.single, .diminished))
        let aug = IntervalQuality.extended(.init(.single, .augmented))
        XCTAssertEqual(dim.inverse, aug)
        XCTAssertEqual(aug.inverse, dim)
    }

    func testInverseMinorMajor() {
        let maj = IntervalQuality.imperfect(.major)
        let min = IntervalQuality.imperfect(.minor)
        XCTAssertEqual(maj.inverse, min)
        XCTAssertEqual(min.inverse, maj)
    }

    func testInversePerfect() {
        let perfect = IntervalQuality.perfect(.perfect)
        XCTAssertEqual(perfect.inverse, perfect)
    }

    func testExtendedDescription() {
        let extended = IntervalQuality.Extended(.triple, .augmented)
        print(extended)
    }
}
