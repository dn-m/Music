//
//  DiatonicIntervalTests.swift
//  PitchTests
//
//  Created by James Bean on 10/10/18.
//

import XCTest
import Pitch

class DiatonicIntervalTests: XCTestCase {

    let reasonableFiniteSubset: [DiatonicInterval] = [
        .d1, .unison, .A1,
        .d2, .m2, .M2, .A2,
        .d3, .m3, .M3, .A3,
        .d4, .P4, .A4,
        .d5, .P5, .A5,
        .d6, .m6, .M6, .A6,
        .d7, .m7, .M7, .A7
    ]

    // MARK: - API

    func testAPI() {
        let _: DiatonicInterval = .unison
        let _: DiatonicInterval = .init(.minor, .second)
        let _: DiatonicInterval = .init(.perfect, .fifth)
        let _: DiatonicInterval = .init(.perfect, .fourth)
        let _: DiatonicInterval = .init(.augmented, .fifth)
        let _: DiatonicInterval = .init(.diminished, .fifth)
        let _: DiatonicInterval = .init(.augmented, .third)
        let _: DiatonicInterval = .init(.minor, .seventh)
        let _: DiatonicInterval = .init(.triple, .augmented, .seventh)
        let _: DiatonicInterval = .init(.double, .diminished, .fifth)
    }

    func testAPIShouldNotCompile() {
        //let _: DiatonicInterval = .init(.minor, .fifth)
        //let _: DiatonicInterval = .init(.perfect, .second)
    }

    func testDiminishedSemitones() {
        XCTAssertEqual(DiatonicInterval.d1.semitones, -1)
        XCTAssertEqual(DiatonicInterval.d2.semitones, 0)
        XCTAssertEqual(DiatonicInterval.d3.semitones, 2)
        XCTAssertEqual(DiatonicInterval.d4.semitones, 4)
        XCTAssertEqual(DiatonicInterval.d5.semitones, 6)
        XCTAssertEqual(DiatonicInterval.d6.semitones, 7)
        XCTAssertEqual(DiatonicInterval.d7.semitones, 9)
    }

    func testAugmentedSemitones() {
        XCTAssertEqual(DiatonicInterval.A1.semitones, 1)
        XCTAssertEqual(DiatonicInterval.A2.semitones, 3)
        XCTAssertEqual(DiatonicInterval.A3.semitones, 5)
        XCTAssertEqual(DiatonicInterval.A4.semitones, 6)
        XCTAssertEqual(DiatonicInterval.A5.semitones, 8)
        XCTAssertEqual(DiatonicInterval.A6.semitones, 10)
        XCTAssertEqual(DiatonicInterval.A7.semitones, 12)
    }

    // FIXME: Get rid of this
    typealias Ordinal = DiatonicInterval.Number

    func testSecondOrdinalInverseSeventh() {
        XCTAssertEqual(Ordinal.imperfect(.second).inverse, Ordinal.imperfect(.seventh))
    }

    func testInversionPerfectFifthPerfectFourth() {
        let P5 = DiatonicInterval(.perfect, .fifth)
        let P4 = DiatonicInterval(.descending, .perfect, .fourth)
        XCTAssertEqual(P5.inverse, P4)
        XCTAssertEqual(P4.inverse, P5)
    }

    func testInversionMajorSecondMinorSeventh() {
        let M2 = DiatonicInterval(.major, .second)
        let m7 = DiatonicInterval(.descending, .minor, .seventh)
        XCTAssertEqual(M2.inverse, m7)
        XCTAssertEqual(m7.inverse, M2)
    }

    func testInversionMajorThirdMinorSixth() {
        let M3 = DiatonicInterval(.descending, .major, .third)
        let m6 = DiatonicInterval(.ascending, .minor, .sixth)
        XCTAssertEqual(M3.inverse, m6)
        XCTAssertEqual(m6.inverse, M3)
        
    }

    func testAbsoluteNamedIntervalOrdinalInversion() {
        let sixth = DiatonicInterval.Number.imperfect(.sixth)
        let expected = DiatonicInterval.Number.imperfect(.third)
        XCTAssertEqual(sixth.inverse, expected)
    }

    func testDoubleAugmentedThirdDoubleDiminishedSixth() {
        let AA3 = DiatonicInterval(.ascending, .double, .augmented, .third)
        let dd6 = DiatonicInterval(.descending, .double, .diminished, .sixth)
        XCTAssertEqual(AA3.inverse, dd6)
        XCTAssertEqual(dd6.inverse, AA3)
    }

    func testPerfectOrdinalUnisonInverse() {
        let unison = DiatonicInterval.Number.perfect(.unison)
        let expected = DiatonicInterval.Number.perfect(.unison)
        XCTAssertEqual(unison.inverse, expected)
    }

    func testPerfectOrdinalFourthFifthInverse() {
        let fourth = DiatonicInterval.Number.perfect(.fourth)
        let fifth = DiatonicInterval.Number.perfect(.fifth)
        XCTAssertEqual(fourth.inverse, fifth)
        XCTAssertEqual(fifth.inverse, fourth)
    }

    // MARK: - Group Axioms

    func testIdentity() {
        reasonableFiniteSubset.forEach { XCTAssertEqual($0 + .unison, $0) }
    }

    func testInverse() {
        reasonableFiniteSubset.forEach { XCTAssertEqual($0 + $0.inverse, .unison) }
    }

    // The `DiatonicInterval` is an Abelian group
    func testCommutativity() {
        zip(reasonableFiniteSubset, reasonableFiniteSubset).forEach {
            XCTAssertEqual($0 + $1, $1 + $0)
        }
    }
}
