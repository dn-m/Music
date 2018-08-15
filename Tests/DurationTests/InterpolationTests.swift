//
//  TempoTests.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//
import XCTest
import DataStructures
import Math
@testable import Duration

class TempoInterpolationTests: XCTestCase {

    func testTempoLinear_60to120() {

        let interp = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.linear
        )
        
        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds = [60, 71.35, 84.85, 100.91, 120]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqual(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoPowerIn2_60to120() {

        let interp = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.powerIn(exponent: 2)
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds = [60, 62.66, 71.35, 88.61, 120]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqual(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoPowerIn3_60to120() {

        let interp = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.powerIn(exponent: 3)
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds = [60, 60.65, 65.43, 80.38, 120]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqual(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoLinear_120to60() {

        let interp = Tempo.Interpolation(
            start: Tempo(120),
            end: Tempo(60),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.linear
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds = [120, 100.91, 84.85, 71.35, 60]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqual(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoPowerIn2_120to60() {

        let interp = Tempo.Interpolation(
            start: Tempo(120),
            end: Tempo(60),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.powerIn(exponent: 2)
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds = [120, 114.91, 100.90, 81.25, 60]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqual(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoPowerIn3_120to60() {

        let interp = Tempo.Interpolation(
            start: Tempo(120),
            end: Tempo(60),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.powerIn(exponent: 3)
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds = [120, 118.70, 110.04, 89.57, 60]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqual(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetLinear_60to60() {

        let interp = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(60),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.linear
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds: [Double] = [0, 1, 2, 3, 4]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(for: offset)
            XCTAssertEqual(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetLinear_120to120() {

        let interp = Tempo.Interpolation(
            start: Tempo(120),
            end: Tempo(120),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.linear
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds: [Double] = [0, 1/2, 1, 3/2, 2]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(for: offset)
            XCTAssertEqual(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetLinear_60to120_wholeNoteDuration() {

        let interp = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.linear
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds: [Double] = [0, 0.92, 1.69, 2.34, 2.89]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(for: offset)
            XCTAssertEqual(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetLinear_60to120_dottedHalfDuration() {
        
        let interp = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            length: Fraction(3,4),
            easing: Tempo.Interpolation.Easing.linear
        )

        let offsets = [Fraction(0,1), Fraction(3,16), Fraction(3,8), Fraction(9,16), Fraction(3,4)]
        let expecteds: [Double] = [0, 0.68, 1.26, 1.75, 2.16]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(for: offset)
            XCTAssertEqual(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetLinear_120to60_wholeNoteDuration() {

        let interp = Tempo.Interpolation(
            start: Tempo(120),
            end: Tempo(60),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.linear
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds = [
            0, 0.54593633303067,
            1.1951677046092,
            1.9672382709734,
            2.8853900817779
        ]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(for: offset)
            XCTAssertEqual(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetPowerIn2_60to60() {

        let interp = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(60),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.powerIn(exponent:2)
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds: [Double] = [0, 1, 2, 3, 4]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(for: offset)
            XCTAssertEqual(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetPowerIn2_60to120() {

        let interp = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.powerIn(exponent:2)
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds: [Double] = [0, 0.99, 1.89, 2.65, 3.24]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(for: offset)
            XCTAssertEqual(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetPowerIn2_120to60() {

        let interp = Tempo.Interpolation(
            start: Tempo(120),
            end: Tempo(60),
            length: Fraction(1,1),
            easing: Tempo.Interpolation.Easing.powerIn(exponent:2)
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1)]
        let expecteds: [Double] = [0, 0.51, 1.06, 1.72, 2.58]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(for: offset)
            XCTAssertEqual(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    // Tests what happens when the desired resolution is twice that of the
    // approximation resolution
    func testSecondsOffsetPowerIn2_120to60_tooSmallResolution() {

        let interp = Tempo.Interpolation(
            start: Tempo(120),
            end: Tempo(60),
            length: Fraction(2049,2048),
            easing: Tempo.Interpolation.Easing.powerIn(exponent:2)
        )

        let offsets = [Fraction(0,1), Fraction(1,4), Fraction(1,2), Fraction(3,4), Fraction(1,1), Fraction(2049,2048)]
        let expecteds: [Double] = [0, 0.51, 1.06, 1.72, 2.575, 2.576]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(for: offset)
            XCTAssertEqual(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    func testDurationStatic60BPM() {
        let interp = Tempo.Interpolation(start: Tempo(60), end: Tempo(60), length: Fraction(4,4))
        XCTAssertEqual(interp.duration, 4)
    }

    func testDurationStatic120BPM() {
        let interp = Tempo.Interpolation(start: Tempo(120), end: Tempo(120), length: Fraction(4,4))
        XCTAssertEqual(interp.duration, 2)
    }

    func testDurationStatic30BPM() {
        let interp = Tempo.Interpolation(start: Tempo(30), end: Tempo(30), length: Fraction(4,4))
        XCTAssertEqual(interp.duration, 8)
    }
}
