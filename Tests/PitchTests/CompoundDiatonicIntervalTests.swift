//
//  CompoundDiatonicIntervalTests.swift
//  PitchTests
//
//  Created by James Bean on 8/24/19.
//

import XCTest
import Pitch

class CompoundDiatonicIntervalTests: XCTestCase {

    let reasonableFiniteSubset: [CompoundDiatonicInterval] = [
        .d1, .unison, .A1,
        .d2, .m2, .M2, .A2,
        .d3, .m3, .M3, .A3,
        .d4, .P4, .A4,
        .d5, .P5, .A5,
        .d6, .m6, .M6, .A6,
        .d7, .m7, .M7, .A7
    ]

    func testAddLessThanAnOctave() {
        let result: CompoundDiatonicInterval = .m2 + .P4
        let expected: CompoundDiatonicInterval = .d5
        XCTAssertEqual(result, expected)
    }

    func testAddEqualToOctave() {
        let result: CompoundDiatonicInterval = .P4 + .P5
        let expected: CompoundDiatonicInterval = .octave
        XCTAssertEqual(result, expected)
    }

    func testAddMoreThanAnOctave() {
        let result: CompoundDiatonicInterval = .P5 + .m6
        let expected = CompoundDiatonicInterval(.m3, displacedBy: 1)
        XCTAssertEqual(result, expected)
    }

    func testSubtractNoOctaveDisplacement() {
        let result: CompoundDiatonicInterval = .M3 - .M2
        let expected: CompoundDiatonicInterval = .M2
        XCTAssertEqual(result, expected)
    }

    func testSubtractWithOctaveDisplacement() {
        let result: CompoundDiatonicInterval = .m3 - .m6
        let orderedInterval = DiatonicInterval(.descending, .perfect, .fourth)
        let expected: CompoundDiatonicInterval = CompoundDiatonicInterval(orderedInterval)
        XCTAssertEqual(result, expected)
    }

    func testOctaveSubtractingCompoundInterval() {
        let result: CompoundDiatonicInterval = .octave - (.M3 + .m3)
        let expected: CompoundDiatonicInterval = .P4
        XCTAssertEqual(result, expected)
    }

    // MARK: - Additive Monoid Axioms

    func testIdentity() {
        reasonableFiniteSubset.forEach { XCTAssertEqual($0 + .unison, $0) }
    }
}
