//
//  OrderedIntervalDescriptorTests.swift
//  PitchTests
//
//  Created by James Bean on 10/10/18.
//

import XCTest
import Pitch

class OrderedIntervalDescriptorTests: XCTestCase {

    typealias Ordinal = OrderedIntervalDescriptor.Ordinal

    func testSecondOrdinalInverseSeventh() {
        XCTAssertEqual(Ordinal.imperfect(.second).inverse, Ordinal.imperfect(.seventh))
    }

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
        let sixth = OrderedIntervalDescriptor.Ordinal.imperfect(.sixth)
        let expected = OrderedIntervalDescriptor.Ordinal.imperfect(.third)
        XCTAssertEqual(sixth.inverse, expected)
    }

    func testDoubleAugmentedThirdDoubleDiminishedSixth() {
        let AA3 = OrderedIntervalDescriptor(.ascending, .double, .augmented, .third)
        let dd6 = OrderedIntervalDescriptor(.descending, .double, .diminished, .sixth)
        XCTAssertEqual(AA3.inverse, dd6)
        XCTAssertEqual(dd6.inverse, AA3)
    }

    func testPerfectOrdinalUnisonInverse() {
        let unison = OrderedIntervalDescriptor.Ordinal.perfect(.unison)
        let expected = OrderedIntervalDescriptor.Ordinal.perfect(.unison)
        XCTAssertEqual(unison.inverse, expected)
    }

    func testPerfectOrdinalFourthFifthInverse() {
        let fourth = OrderedIntervalDescriptor.Ordinal.perfect(.fourth)
        let fifth = OrderedIntervalDescriptor.Ordinal.perfect(.fifth)
        XCTAssertEqual(fourth.inverse, fifth)
        XCTAssertEqual(fifth.inverse, fourth)
    }
}
