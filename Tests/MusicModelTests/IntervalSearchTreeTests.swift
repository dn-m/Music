//
//  IntervalSearchTreeTests.swift
//  MusicModel
//
//  Created by James Bean on 9/9/18.
//

import XCTest
import Math
@testable import MusicModel

class IntervalSearchTreeTests: XCTestCase {

    let intervalTree: IntervalSearchTree<Fraction,[AttributeID]> = {
        let a = Fraction(2,8) ..< Fraction(9,8)
        let b = Fraction(3,8) ..< Fraction(8,8)
        let c = Fraction(5,8) ..< Fraction(7,8)
        let d = Fraction(6,8) ..< Fraction(13,8)
        let nodes: [ISTPayload<Fraction,[AttributeID]>] = [a,b,c,d].map { interval in
            ISTPayload(interval: interval, value: [])
        }
        return IntervalSearchTree<Fraction,[AttributeID]>(nodes)
    }()

    func testInsertMaxUpdated() {
        var ist = IntervalSearchTree<Fraction,[AttributeID]>()

        // Insert initial interval
        ist.insert(ISTPayload(interval: Fraction(3,4) ..< Fraction(8,4), value: []))
        let root = ist.root!
        XCTAssertEqual(root.value.max, Fraction(8,4))

        // Insert interval with a lower bound < current min
        ist.insert(ISTPayload(interval: Fraction(1,4) ..< Fraction(10,4), value: []))
        XCTAssertEqual(root.value.max, Fraction(10,4))

        // Insert interval with an upper bound > current max
        ist.insert(ISTPayload(interval: Fraction(12,14) ..< Fraction(16,4), value: []))
        XCTAssertEqual(root.value.max, Fraction(16,4))
    }

    func testIntervalNotContainedLessThan() {
        let searchInterval = Fraction(0,8) ..< Fraction(2,8)
        XCTAssertEqual(intervalTree.intervals(overlapping: searchInterval), [])
    }

    func testIntervalNotContainedGreaterThan() {
        let searchInterval = Fraction(14,8) ..< Fraction(16,8)
        XCTAssertEqual(intervalTree.intervals(overlapping: searchInterval), [])
    }

    func testIntervalContainsSingle() {
        let searchInterval = Fraction(11,8) ..< Fraction(13,8)
        let expected: [ISTPayload<Fraction,[AttributeID]>] = [
            ISTPayload(interval: Fraction(6,8) ..< Fraction(13,8), value: [])
        ]
        XCTAssertEqual(intervalTree.intervals(overlapping: searchInterval), expected)
    }

    func testIntervalContainsMultiple() {
        // TODO
    }
}
