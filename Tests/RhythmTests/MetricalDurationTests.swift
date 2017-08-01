//
//  MetricalDurationTests.swift
//  Rhythm
//
//  Created by James Bean on 1/28/17.
//
//

import XCTest
import Math
import Rhythm

class MetricalDurationTests: XCTestCase {

    func testComparableReduced() {
        let a = MetricalDuration(1,8)
        let b = MetricalDuration(1,16)
        XCTAssertLessThan(b,a)
    }

    func testInitOperator() {
        _ = 1/>2
        _ = 1 /> 2
    }

    func testRange() {

        let a = 1/>2...4/>8
        let b = 3/>16...5/>4

        _ = a.relation(with: b)
    }
}
