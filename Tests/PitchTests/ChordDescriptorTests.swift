//
//  ChordDescriptorTests.swift
//  PitchTests
//
//  Created by James Bean on 10/23/18.
//

import XCTest
import Pitch

class ChordDescriptorTests: XCTestCase {

    func testInitAPI() {
        let _: ChordDescriptor = [.M3, .m3] // major
        let _: ChordDescriptor = [.m3, .M3] // minor
        let _: ChordDescriptor = [.m3, .m3] // diminished
        let _: ChordDescriptor = [.M3, .M3] // augmented
    }

    func testInversionRootPosition() {
        let major = ChordDescriptor([.M3, .m3])
        let result = major.inversion(0)
        XCTAssertEqual(major, result)
    }

    func testFirstInversion() {
        let major: ChordDescriptor = [.M3, .m3]
        let result = major.inversion(1)
        let expected: ChordDescriptor = [.m3, .P4]
        XCTAssertEqual(result, expected)
    }

    func testSecondInversion() {
        let major: ChordDescriptor = [.M3, .m3]
        let result = major.inversion(2)
        let expected: ChordDescriptor = [.P4, .M3]
        XCTAssertEqual(result, expected)
    }

    func testThirdInversion() {
        let majorSeventh: ChordDescriptor = [.M3, .m3, .M3]
        let result = majorSeventh.inversion(3)
        let expected: ChordDescriptor = [.m2, .M3, .m3]
        XCTAssertEqual(result, expected)
    }
}
