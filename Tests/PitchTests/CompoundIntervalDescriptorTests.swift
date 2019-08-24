//
//  CompoundIntervalDescriptorTests.swift
//  PitchTests
//
//  Created by James Bean on 8/24/19.
//

import XCTest
import Pitch

class CompoundIntervalDescriptorTests: XCTestCase {

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
}
