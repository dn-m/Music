//
//  OrderedIntervalDescriptorTests.swift
//  PitchTests
//
//  Created by James Bean on 10/10/18.
//

import XCTest
import Pitch

class OrderedIntervalDescriptorTests: XCTestCase {

    let reasonableFiniteSubset: [OrderedIntervalDescriptor] = [
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
        let _: OrderedIntervalDescriptor = .unison
        let _: OrderedIntervalDescriptor = .init(.minor, .second)
        let _: OrderedIntervalDescriptor = .init(.perfect, .fifth)
        let _: OrderedIntervalDescriptor = .init(.perfect, .fourth)
        let _: OrderedIntervalDescriptor = .init(.augmented, .fifth)
        let _: OrderedIntervalDescriptor = .init(.diminished, .fifth)
        let _: OrderedIntervalDescriptor = .init(.augmented, .third)
        let _: OrderedIntervalDescriptor = .init(.minor, .seventh)
        let _: OrderedIntervalDescriptor = .init(.triple, .augmented, .seventh)
        let _: OrderedIntervalDescriptor = .init(.double, .diminished, .fifth)
    }

    func testAPIShouldNotCompile() {
        //let _: OrderedIntervalDescriptor = .init(.minor, .fifth)
        //let _: OrderedIntervalDescriptor = .init(.perfect, .second)
    }

    func testDiminishedSemitones() {
        XCTAssertEqual(OrderedIntervalDescriptor.d1.semitones, -1)
        XCTAssertEqual(OrderedIntervalDescriptor.d2.semitones, 0)
        XCTAssertEqual(OrderedIntervalDescriptor.d3.semitones, 2)
        XCTAssertEqual(OrderedIntervalDescriptor.d4.semitones, 4)
        XCTAssertEqual(OrderedIntervalDescriptor.d5.semitones, 6)
        XCTAssertEqual(OrderedIntervalDescriptor.d6.semitones, 7)
        XCTAssertEqual(OrderedIntervalDescriptor.d7.semitones, 9)
    }

    func testAugmentedSemitones() {
        XCTAssertEqual(OrderedIntervalDescriptor.A1.semitones, 1)
        XCTAssertEqual(OrderedIntervalDescriptor.A2.semitones, 3)
        XCTAssertEqual(OrderedIntervalDescriptor.A3.semitones, 5)
        XCTAssertEqual(OrderedIntervalDescriptor.A4.semitones, 6)
        XCTAssertEqual(OrderedIntervalDescriptor.A5.semitones, 8)
        XCTAssertEqual(OrderedIntervalDescriptor.A6.semitones, 10)
        XCTAssertEqual(OrderedIntervalDescriptor.A7.semitones, 12)
    }

    // FIXME: Get rid of this
    typealias Ordinal = OrderedIntervalDescriptor.Number

    func testSecondOrdinalInverseSeventh() {
        XCTAssertEqual(Ordinal.imperfect(.second).inverse, Ordinal.imperfect(.seventh))
    }

    func testInversionPerfectFifthPerfectFourth() {
        let P5 = OrderedIntervalDescriptor(.perfect, .fifth)
        let P4 = OrderedIntervalDescriptor(.descending, .perfect, .fourth)
        XCTAssertEqual(P5.inverse, P4)
        XCTAssertEqual(P4.inverse, P5)
    }

    func testInversionMajorSecondMinorSeventh() {
        let M2 = OrderedIntervalDescriptor(.major, .second)
        let m7 = OrderedIntervalDescriptor(.descending, .minor, .seventh)
        XCTAssertEqual(M2.inverse, m7)
        XCTAssertEqual(m7.inverse, M2)
    }

    func testInversionMajorThirdMinorSixth() {
        let M3 = OrderedIntervalDescriptor(.descending, .major, .third)
        let m6 = OrderedIntervalDescriptor(.ascending, .minor, .sixth)
        XCTAssertEqual(M3.inverse, m6)
        XCTAssertEqual(m6.inverse, M3)
        
    }

    func testAbsoluteNamedIntervalOrdinalInversion() {
        let sixth = OrderedIntervalDescriptor.Number.imperfect(.sixth)
        let expected = OrderedIntervalDescriptor.Number.imperfect(.third)
        XCTAssertEqual(sixth.inverse, expected)
    }

    func testDoubleAugmentedThirdDoubleDiminishedSixth() {
        let AA3 = OrderedIntervalDescriptor(.ascending, .double, .augmented, .third)
        let dd6 = OrderedIntervalDescriptor(.descending, .double, .diminished, .sixth)
        XCTAssertEqual(AA3.inverse, dd6)
        XCTAssertEqual(dd6.inverse, AA3)
    }

    func testPerfectOrdinalUnisonInverse() {
        let unison = OrderedIntervalDescriptor.Number.perfect(.unison)
        let expected = OrderedIntervalDescriptor.Number.perfect(.unison)
        XCTAssertEqual(unison.inverse, expected)
    }

    func testPerfectOrdinalFourthFifthInverse() {
        let fourth = OrderedIntervalDescriptor.Number.perfect(.fourth)
        let fifth = OrderedIntervalDescriptor.Number.perfect(.fifth)
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

    // The `OrderedIntervalDescriptor` is an Abelian group
    func testCommutativity() {
        zip(reasonableFiniteSubset, reasonableFiniteSubset).forEach {
            XCTAssertEqual($0 + $1, $1 + $0)
        }
    }
}
