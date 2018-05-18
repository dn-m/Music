//
//  MeterCollectionTests.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import XCTest
import Restructure
import StructureWrapping
import Combinatorics
import Math
import Meter

class MeterCollectionTests: XCTestCase {

    var meters: Meter.Collection {
        let builder = Meter.Collection.Builder()
        (0..<500).forEach { _ in
            let beats = Int.random(in: 3..<9)
            let subdivision = [16,8,4].randomElement()!
            builder.add(.init(Meter(beats,subdivision)))
        }
        return builder.build()
    }

    func testFragmentOutOfRange() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(13,4) ..< Fraction(14,4)]
        XCTAssert(fragment.base.isEmpty)
    }

    func testFragmentRangeWithinSingleMeter() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(5,4) ..< Fraction(6,4)]
        let expected = Meter.Collection([
            Meter.Fragment(Meter(3,4), in: Fraction(1,4)..<Fraction(2,4))
        ])
        XCTAssertEqual(fragment, expected)
    }

    func testTruncatingFragment() {

        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(2,4) ..< Fraction(9,4)]

        let expected = [
            Meter.Fragment(Meter(4,4), in: Fraction(2,4)..<Fraction(4,4)),
            Meter.Fragment(Meter(3,4)),
            Meter.Fragment(Meter(5,4), in: Fraction(0,4)..<Fraction(2,4))
        ]

        XCTAssertEqual(fragment.base.map { $0.1 }, expected)
    }

    func testFragmentUpperBoundBeyondEnd() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(8,4) ..< Fraction(13,4)]
        let expected = [Meter.Fragment(Meter(5,4), in: Fraction(1,4)..<Fraction(5,4))]
        XCTAssertEqual(fragment.base.map { $0.1 }, expected)
    }

    func testFragmentsFromTutschkuUnder() {

        let meters = Meter.Collection([
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(3,4),
            Meter(3,8),
            Meter(7,4),
            Meter(8,4),
            Meter(8,4),
            Meter(8,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,4),
            Meter(5,8),
            Meter(5,8),
            Meter(7,4),
            Meter(7,4),
            Meter(3,8),
            Meter(2,4),
            Meter(1,8),
            Meter(6,4),
            Meter(6,4),
            Meter(5,8),
            Meter(7,4),
            Meter(1,8),
            Meter(7,4),
            Meter(5,8),
            Meter(2,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,4),
            Meter(5,8),
            Meter(2,4),
            Meter(5,8),
            Meter(7,4),
            Meter(3,8),
            Meter(1,8),
            Meter(7,4),
            Meter(1,8),
            Meter(2,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(6,4),
            Meter(7,4),
            Meter(7,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(7,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(7,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(7,4),
            Meter(6,4),
            Meter(3,4),
            Meter(4,4),
            Meter(5,4),
            Meter(7,4),
            Meter(6,4),
            Meter(7,4),
            Meter(7,4),
            Meter(3,4),
            Meter(6,4),
            Meter(7,4),
            Meter(5,4),
            Meter(6,4),
            Meter(7,4),
            Meter(5,4),
            Meter(6,4),
            Meter(6,4),
            Meter(5,4),
            Meter(6,4),
            Meter(7,4),
            Meter(5,4),
            Meter(6,4),
            Meter(6,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(6,4),
            Meter(3,4),
            Meter(5,4),
            Meter(7,4),
            Meter(3,4),
            Meter(1,4),
            Meter(5,4),
            Meter(7,4),
            Meter(1,4),
            Meter(7,4),
            Meter(2,4),
            Meter(5,4),
            Meter(3,4),
            Meter(1,4),
            Meter(7,4),
            Meter(2,4),
            Meter(5,4),
            Meter(3,4),
            Meter(7,4),
            Meter(1,4),
            Meter(3,4),
            Meter(5,4),
            Meter(1,4),
            Meter(7,4),
            Meter(3,4),
            Meter(7,4),
            Meter(5,4),
            Meter(2,4),
            Meter(4,4),
            Meter(4,4),
            Meter(6,4),
            Meter(2,4),
            Meter(8,4),
            Meter(8,4),
            Meter(1,4),
            Meter(4,4),
            Meter(2,4),
            Meter(5,4),
            Meter(4,4),
            Meter(1,4),
            Meter(4,4),
            Meter(1,4),
            Meter(7,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(5,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(7,4),
            Meter(1,4),
            Meter(2,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(3,4),
            Meter(7,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(3,4),
            Meter(5,4),
            Meter(3,4),
            Meter(7,4),
            Meter(5,4),
            Meter(3,4),
            Meter(7,4),
            Meter(1,4),
            Meter(5,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4)
        ])

        let eventOffsets = [
            Fraction(0,8),
            Fraction(31,8),
            Fraction(69,8),
            Fraction(99,8),
            Fraction(127,8),
            Fraction(147,8),
            Fraction(230,8),
            Fraction(288,8),
            Fraction(332,8),
            Fraction(356,8),
            Fraction(398,8),
            Fraction(416,8),
            Fraction(505,8),
            Fraction(561,8),
            Fraction(603,8),
            Fraction(643,8),
            Fraction(667,8),
            Fraction(691,8),
            Fraction(727,8),
            Fraction(751,8),
            Fraction(775,8),
            Fraction(801,8),
            Fraction(825,8),
            Fraction(851,8),
            Fraction(875,8),
            Fraction(901,8),
            Fraction(939,8),
            Fraction(965,8),
            Fraction(997,8),
            Fraction(1033,8),
            Fraction(1069,8),
            Fraction(1103,8),
            Fraction(1139,8),
            Fraction(1162,8),
            Fraction(1175,8),
            Fraction(1205,8),
            Fraction(1237,8),
            Fraction(1257,8),
            Fraction(1293,8),
            Fraction(1323,8),
            Fraction(1357,8),
            Fraction(1387,8),
            Fraction(1419,8),
            Fraction(1455,8),
            Fraction(1465,8),
            Fraction(1487,8),
            Fraction(1497,8),
            Fraction(1513,8),
            Fraction(1531,8),
            Fraction(1547,8),
            Fraction(1565,8),
            Fraction(1585,8),
            Fraction(1591,8),
            Fraction(1609,8),
            Fraction(1675,8),
            Fraction(1695,8),
            Fraction(1719,8),
            Fraction(1735,8),
            Fraction(1756,8),
            Fraction(1795,8),
            Fraction(1825,8),
            Fraction(1855,8),
            Fraction(1895,8),
            Fraction(1951,8),
            Fraction(1993,8),
            Fraction(2035,8)
        ]

        let ranges = (eventOffsets + meters.length).pairs
        let fragments = ranges.map { start, end in meters[Fraction(start)..<Fraction(end)] }
        let flattenedFragments = fragments.flatMap { fragment in fragment.base.map { $0.1 } }
        XCTAssertEqual(fragments.count, 66)
        XCTAssertEqual(meters.base.count, flattenedFragments.count)
        zip(meters.base.map { $0.1 }, flattenedFragments).forEach { XCTAssertEqual($0,$1) }
    }
}

extension Array {

    var random: Element {
        return self[Int.random(min: startIndex, max: endIndex - 1)]
    }
}
