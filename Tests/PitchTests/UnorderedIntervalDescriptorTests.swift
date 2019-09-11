//
//  UnorderedDiatonicIntervalTests.swift
//  PitchTests
//
//  Created by James Bean on 9/6/19.
//

import XCTest
import Pitch

class UnorderedDiatonicIntervalTests: XCTestCase {

    let reasonableFiniteSubset: [UnorderedDiatonicInterval] = [
        .d1, .unison, .A1,
        .d2, .m2, .M2, .A2,
        .d3, .m3, .M3, .A3,
        .d4, .P4, .A4
    ]

    // MARK: - Additive Monoid Axioms

    func testAddUnison() {
        XCTAssertEqual(UnorderedDiatonicInterval.d1 + .unison, .d1)
    }

    func testIdentity() {
        reasonableFiniteSubset.forEach { XCTAssertEqual($0 + .unison, $0) }
    }
}
