//
//  EasingEvaluateTests.swift
//  For Easing.evaluate(at: x)
//
//  Created by Brian Heim on 5/31/17.
//
//
import XCTest
@testable import Duration

class EasingEvaluateTests: XCTestCase {

    // MARK: Linear

    func testLinear() {

        let x: Double = 0.5
        let ease = Tempo.Interpolation.Easing.linear
        let expected = x
        let result = ease.evaluate(at: x)
        XCTAssertEqual(result, expected)
    }

    // MARK: - PowerIn

    func testPowerInOne() {

        let x: Double = 0.5
        let ease = Tempo.Interpolation.Easing.powerIn(exponent: 1)
        let expected = 0.5
        let result = ease.evaluate(at: x)
        XCTAssertEqual(result, expected)
    }

    func testPowerInTwo() {

        let x: Double = 0.5
        let ease = Tempo.Interpolation.Easing.powerIn(exponent: 2)
        let expected = 0.25
        let result = ease.evaluate(at: x)
        XCTAssertEqual(result, expected)
    }

    func testPowerInHalf() {

        let x: Double = 0.5
        let ease = Tempo.Interpolation.Easing.powerIn(exponent: 0.5)
        let expected = 0.70710678118 // 1 / sqrt(2)
        let result = ease.evaluate(at: x)
        XCTAssertEqual(result, expected, accuracy: 1e-6)
    }

    // MARK: - PowerInOut

    func testPowerInOutOne() {

        let x: Double = 0.25
        let ease = Tempo.Interpolation.Easing.powerInOut(exponent: 1)
        let expected = 0.25
        let result = ease.evaluate(at: x)
        XCTAssertEqual(result, expected)
    }

    func testPowerInOutTwo() {

        let ease = Tempo.Interpolation.Easing.powerInOut(exponent: 2)

        XCTAssertEqual(ease.evaluate(at: 0), 0)
        XCTAssertEqual(ease.evaluate(at: 0.25), 0.125)
        XCTAssertEqual(ease.evaluate(at: 0.5), 0.5)
        XCTAssertEqual(ease.evaluate(at: 0.75), 0.875)
        XCTAssertEqual(ease.evaluate(at: 1), 1)
    }

    func testPowerInOutThree() {

        let ease = Tempo.Interpolation.Easing.powerInOut(exponent: 3)
        XCTAssertEqual(ease.evaluate(at: 0), 0)
        XCTAssertEqual(ease.evaluate(at: 0.25), 0.0625)
        XCTAssertEqual(ease.evaluate(at: 0.5), 0.5)
        XCTAssertEqual(ease.evaluate(at: 0.75), 0.9375)
        XCTAssertEqual(ease.evaluate(at: 1), 1)
    }

    // MARK: - SineInOut

    func testSineInOut() {
        let ease = Tempo.Interpolation.Easing.sineInOut
        let inputs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let sqrt2_recip = 1 / sqrt(2)
        let expecteds: [Double] = [
            0,
            (1 - sqrt2_recip) / 2,
            0.5,
            (1 + sqrt2_recip) / 2,
            1
        ]

        for (input, expected) in zip(inputs, expecteds) {
            XCTAssertEqual(ease.evaluate(at: input), expected, accuracy: 1e-12)
        }
    }
}
