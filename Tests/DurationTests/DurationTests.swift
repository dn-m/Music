//
//  DurationTests.swift
//  Rhythm
//
//  Created by James Bean on 1/28/17.
//
//

import XCTest
import Math
import Duration

class DurationTests: XCTestCase {

    func testComparableReduced() {
        let a = Duration(1,8)
        let b = Duration(1,16)
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
