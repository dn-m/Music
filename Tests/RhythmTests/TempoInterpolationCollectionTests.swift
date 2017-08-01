//
//  TempoInterpolationCollectionTests.swift
//  Rhythm
//
//  Created by James Bean on 7/18/17.
//
//

import XCTest
import Math
@testable import Rhythm

class StratumTests: XCTestCase {

    func testBuilderSingleInterpolation() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(90), at: Fraction(4,4))
        _ = builder.build()
        // TODO: Assert
    }

    func testBuilderSingleStatic() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero)
        builder.add(Tempo(90), at: Fraction(4,4))
        let stratum = builder.build()
        print(stratum)
    }

    func testBuilderMultipleStatic() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(120), at: Fraction(3,4))
        let stratum = builder.build()
        print(stratum)
    }

    func testSimpleFragment() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(120), at: Fraction(32,4))
        let stratum: Tempo.Interpolation.Collection = builder.build()
        let fragment = stratum[.zero ..< Fraction(32,4)]
        XCTAssertEqual(fragment.count, 1)
    }

    func testMoreComplexFragment() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(240), at: Fraction(4,4), interpolating: false)
        builder.add(Tempo(120), at: Fraction(16,4), interpolating: false)
        builder.add(Tempo(120), at: Fraction(32,4), interpolating: true)
        builder.add(Tempo(120), at: Fraction(48,4), interpolating: true)
        let stratum = builder.build()
        let fragment = stratum[Fraction(8,4) ..< Fraction(48,4)]

        // [8 -> 16, 16 -> 32, 32 -> 48]
        XCTAssertEqual(fragment.count, 3)
    }

    func testFragment() {
        let builder = Tempo.Interpolation.Collection.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(30), at: Fraction(4,4), interpolating: false)
        builder.add(Tempo(120), at: Fraction(16,4), interpolating: true)
        builder.add(Tempo(60), at: Fraction(32,4), interpolating: false)
        let stratum = builder.build()
        let fragment = stratum[Fraction(3,4) ..< Fraction(17,4)]

        // [3 -> 4, 4 -> 16, 16 -> 17]
        XCTAssertEqual(fragment.count, 3)
    }
}
