//
//  TempoTests.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import XCTest
import Math
@testable import Duration

class TempoTests: XCTestCase {

    func testInitIntegerLiteral() {
        let tempo: Tempo = 79
        XCTAssertEqual(tempo, Tempo(79, subdivision: 4))
    }

    func testInitFloatLiteral() {
        let tempo: Tempo = 3.14159
        XCTAssertEqual(tempo, Tempo(3.14159, subdivision: 4))
    }

    func testTempoRespellingSubdivision() {
        let original = Tempo(60, subdivision: 4)
        let respelled = original.respelling(subdivision: 16)
        let expected = Tempo(240, subdivision: 16)
        XCTAssertEqual(respelled, expected)
    }

    func testInterpolationStatic60BPMSecondsOffsets() {
        let interpolation = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(60),
            length: Fraction(4,4),
            easing: .linear
        )
        let beatOffsets = (0...4).map { Fraction($0,4) }
        let secondsOffsets = beatOffsets.map(interpolation.secondsOffset)
        let expected = (0...4).map { Double($0) }
        XCTAssertEqual(secondsOffsets, expected)
    }
}
