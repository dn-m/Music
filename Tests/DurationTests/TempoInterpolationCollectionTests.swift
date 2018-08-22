//
//  TempoInterpolationCollectionTests.swift
//  Rhythm
//
//  Created by James Bean on 7/18/17.
//
//

import XCTest
import Math
@testable import Duration

class TempoInterpolationCollectionTests: XCTestCase {

    func testBuilderSingleStatic() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero)
        builder.add(Tempo(90), at: Fraction(4,4))
        let interpolations = builder.build()
        let expected = Tempo.Interpolation.Fragment(
            Tempo.Interpolation(
                start: Tempo(60),
                end: Tempo(60),
                length: Fraction(4,4),
                easing: .linear
            )
        )
        XCTAssertEqual(Array(interpolations.offsets), [Fraction(0,4)])
        XCTAssertEqual(Array(interpolations.segments), [expected])
    }

    func testBuilderSingleInterpolation() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero, easing: .linear)
        builder.add(Tempo(90), at: Fraction(4,4))
        let interpolations = builder.build()
        let expected = Tempo.Interpolation.Fragment(
            Tempo.Interpolation(
                start: Tempo(60),
                end: Tempo(90),
                length: Fraction(4,4),
                easing: .linear
            )
        )
        XCTAssertEqual(interpolations.map { _, values in values }, [expected])
    }

    func testSimpleFragment() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero, easing: .linear)
        builder.add(Tempo(120), at: Fraction(32,4))
        let stratum: Tempo.Interpolation.Collection = builder.build()
        let fragment = stratum[.zero ..< Fraction(32,4)]
        let expected = Tempo.Interpolation.Fragment(
            Tempo.Interpolation(start: Tempo(60), end: Tempo(120), length: Fraction(32,4))
        )
        XCTAssertEqual(fragment.count, 1)
        XCTAssertEqual(fragment.segments.first!, expected)
    }

    func testMoreComplexFragment() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero, easing: .linear)
        builder.add(Tempo(240), at: Fraction(4,4), easing: nil)
        builder.add(Tempo(120), at: Fraction(16,4), easing: nil)
        builder.add(Tempo(120), at: Fraction(32,4), easing: .linear)
        builder.add(Tempo(120), at: Fraction(48,4), easing: .linear)
        let interpolations = builder.build()
        let fragment = interpolations[Fraction(8,4) ..< Fraction(48,4)]
        let a = Tempo.Interpolation(start: Tempo(240), end: Tempo(240), length: Fraction(12,4))
        let b = Tempo.Interpolation(start: Tempo(120), end: Tempo(120), length: Fraction(16,4))
        let c = Tempo.Interpolation(start: Tempo(120), end: Tempo(120), length: Fraction(16,4))
        let fragmentA = Tempo.Interpolation.Fragment(a, in: Fraction(4,4)..<Fraction(12,4))
        let fragmentB = Tempo.Interpolation.Fragment(b)
        let fragmentC = Tempo.Interpolation.Fragment(c)
        let expected = [fragmentA, fragmentB, fragmentC]
        XCTAssertEqual(Array(fragment.segments), expected)
    }

    func testFragment() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero, easing: .linear)
        builder.add(Tempo(30), at: Fraction(4,4))
        builder.add(Tempo(120), at: Fraction(16,4), easing: .linear)
        builder.add(Tempo(60), at: Fraction(32,4))
        let interpolations = builder.build()
        let fragment = interpolations[Fraction(3,4) ..< Fraction(17,4)]
        let a = Tempo.Interpolation(start: Tempo(60), end: Tempo(30), length: Fraction(4,4))
        let b = Tempo.Interpolation(start: Tempo(30), end: Tempo(30), length: Fraction(12,4))
        let c = Tempo.Interpolation(start: Tempo(120), end: Tempo(60), length: Fraction(16,4))
        let fragmentA = Tempo.Interpolation.Fragment(a, in: Fraction(3,4)..<Fraction(4,4))
        let fragmentB = Tempo.Interpolation.Fragment(b)
        let fragmentC = Tempo.Interpolation.Fragment(c, in: Fraction(0,4)..<Fraction(1,4))
        let expected = [fragmentA, fragmentB, fragmentC]
        XCTAssertEqual(Array(fragment.segments), expected)
    }
}
