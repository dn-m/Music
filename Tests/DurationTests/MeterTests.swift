//
//  MeterTests.swift
//  DurationTests
//
//  Created by James Bean on 8/14/18.
//

import XCTest
import Math
import Duration

class MeterTests: XCTestCase {

    func testNormalMeter() {
        let _ = Meter(4,4)
        let _ = Meter(3,8)
        let _ = Meter(17,32)
    }

    func testIrrationalMeter() {
        let _ = Meter(4,1)
        let _ = Meter(5,3)
        let _ = Meter(5,6)
        let _ = Meter(5,28)
        let _ = Meter(17,56)
        let _ = Meter(1,18)
    }

    func testFractionalMeter() {
        let _ = Meter(Fraction(4,5), 64)
    }

    func testAdditiveMeter() {
        let a = Meter(3,4)
        let b = Meter(Fraction(3,7), 16)
        let _ = a + b
    }

    func testBeatOffsets() {
        let meter = Meter(7,16)
        let expected = (0..<7).map { Fraction($0,16) }
        XCTAssertEqual(meter.beatOffsets, expected)
    }

    func testBeatOffsetsFractional() {
        let meter = Meter(Fraction(2,3),4)
        let expected = [(0,12),(2,12)].map(Fraction.init)
        XCTAssertEqual(meter.beatOffsets, expected)
    }

    func testBeatOffsetsAdditive() {
        let a = Meter(7,32)
        let b = Meter(Fraction(3,7),16)
        let c = Meter(4,4)
        let additive = a + b + c
        let result = additive.beatOffsets
        let expected = [
            (0,32), (1,32), (2,32), (3,32), (4,32), (5,32), (6,32),
            (147,224), (153,224), (159,224),
            (606,224), (662,224), (718,224), (774,224)
        ].map(Fraction.init)
        XCTAssertEqual(result, expected)
    }

    func testMetersSum() {
        let meters = [(1,4),(2,4),(3,4),(5,4)].map(Meter.init)
        let _ = meters.sum.numerator
        let _ = meters.sum.denominator
    }

    func testManyMetersSum() {
        let meters = (0..<10_000).map { _ in Meter(Int.random(in: 1 ..< 8), 4) }
        let sum: Meter = meters.sum
        let _ = sum.numerator
    }
}
