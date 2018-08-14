//
//  MeterTests.swift
//  DurationTests
//
//  Created by James Bean on 8/14/18.
//

import XCTest
import Duration

class MeterTests: XCTestCase {

    func testNormalMeter() {
        let _ = Meter(4,4)
        let _ = Meter(3,8)
        let _ = Meter(17,32)
    }

    func testIrrationalMeter() {
        let _ = Meter(5,3)
        let _ = Meter(5,6)
        let _ = Meter(5,28)
        let _ = Meter(17,56)
        let _ = Meter(1,18)
    }
}
