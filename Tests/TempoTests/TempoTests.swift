//
//  TempoTests.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import XCTest
import Math
@testable import Tempo

class TempoTests: XCTestCase {

    func testTempoRespellingSubdivision() {
        let original = Tempo(60, subdivision: 4)
        XCTAssertEqual(original.respelling(subdivision: 16), Tempo(240, subdivision: 16))
    }

    func testInterpolationNoChange() {

        let interpolation = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(60),
            length: Fraction(4,4)
        )

        for beatOffset in 0...4 {
            let durationOffset = Fraction(beatOffset, 4)
            XCTAssertEqual(
                interpolation.secondsOffset(for: durationOffset),
                Double(beatOffset)
            )
        }
    }
}
