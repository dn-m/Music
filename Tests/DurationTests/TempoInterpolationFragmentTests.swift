//
//  TempoInterpolationFragmentTests.swift
//  DurationTests
//
//  Created by James Bean on 8/15/18.
//

import XCTest
import Math
import Duration

class TempoInterpolationFragmentTests: XCTestCase {

    func testSecondsOffsetStatic120BPMFirstBeats() {
        let interp = Tempo.Interpolation(start: Tempo(60), end: Tempo(60), length: Fraction(4,4))
        let fragment = interp.fragment(in: .zero..<Fraction(2,4))
        XCTAssertEqual(fragment.duration, 2)
    }

    func testSecondsOffsetStatic120BPMMiddleBeats() {
        let interp = Tempo.Interpolation(start: Tempo(60), end: Tempo(60), length: Fraction(4,4))
        let fragment = interp.fragment(in: Fraction(1,4)..<Fraction(3,4))
        XCTAssertEqual(fragment.duration, 2)
    }

    func testSecondsOffsetStatic120BPMLastBeats() {
        let interp = Tempo.Interpolation(start: Tempo(60), end: Tempo(60), length: Fraction(4,4))
        let fragment = interp.fragment(in: Fraction(2,4)..<Fraction(4,4))
        XCTAssertEqual(fragment.duration, 2)
    }
}
