//
//  CompoundIntervalDescriptorTests.swift
//  PitchTests
//
//  Created by James Bean on 8/24/19.
//

import XCTest
import Pitch

class CompoundIntervalDescriptorTests: XCTestCase {

    let reasonableFiniteSubset: [CompoundIntervalDescriptor] = [
        .d1, .unison, .A1,
        .d2, .m2, .M2, .A2,
        .d3, .m3, .M3, .A3,
        .d4, .P4, .A4,
        .d5, .P5, .A5,
        .d6, .m6, .M6, .A6,
        .d7, .m7, .M7, .A7
    ]

    func testAddLessThanAnOctave() {
        let result: CompoundIntervalDescriptor = .m2 + .P4
        let expected: CompoundIntervalDescriptor = .d5
        XCTAssertEqual(result, expected)
    }

    func testAddEqualToOctave() {
        let result: CompoundIntervalDescriptor = .P4 + .P5
        let expected: CompoundIntervalDescriptor = .octave
        XCTAssertEqual(result, expected)
    }

    func testAddMoreThanAnOctave() {
        let result: CompoundIntervalDescriptor = .P5 + .m6
        let expected = CompoundIntervalDescriptor(.m3, displacedBy: 1)
        XCTAssertEqual(result, expected)
    }

    func testSubtractNoOctaveDisplacement() {
        let result: CompoundIntervalDescriptor = .M3 - .M2
        let expected: CompoundIntervalDescriptor = .M2
        XCTAssertEqual(result, expected)
    }

    func testSubtractWithOctaveDisplacement() {
        let result: CompoundIntervalDescriptor = .m3 - .m6
        let orderedInterval = OrderedIntervalDescriptor(.descending, .perfect, .fourth)
        let expected: CompoundIntervalDescriptor = CompoundIntervalDescriptor(orderedInterval)
        XCTAssertEqual(result, expected)
    }

    func testOctaveSubtractingCompoundInterval() {
        let result: CompoundIntervalDescriptor = .octave - (.M3 + .m3)
        let expected: CompoundIntervalDescriptor = .P4
        XCTAssertEqual(result, expected)
    }

    // MARK: - Additive Monoid Axioms

    func testIdentity() {
        reasonableFiniteSubset.forEach { XCTAssertEqual($0 + .unison, $0) }
    }
}
