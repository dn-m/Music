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

    let intervalTree: IntervalSearchTree<Fraction,Set<Int>> = {
        let a = Fraction(2,8) ..< Fraction(9,8)
        let b = Fraction(3,8) ..< Fraction(8,8)
        let c = Fraction(5,8) ..< Fraction(7,8)
        let d = Fraction(6,8) ..< Fraction(13,8)
        let nodes = [a,b,c,d].map { interval in
            IntervalSearchTree<Fraction,Set<Int>>.Node(interval: interval, value: [])
        }
        return IntervalSearchTree(nodes)
    }()

    func testInsertMaxUpdated() {
        var ist = IntervalSearchTree<Fraction,Set<AttributeID>>()

        // Insert initial interval
        ist.insert(.init(interval: Fraction(3,4) ..< Fraction(8,4), value: []))
        let root = ist.base.root!
        XCTAssertEqual(root.value.max, Fraction(8,4))

        // Insert interval with a lower bound < current min
        ist.insert(.init(interval: Fraction(1,4) ..< Fraction(10,4), value: []))
        XCTAssertEqual(root.value.max, Fraction(10,4))

        // Insert interval with an upper bound > current max
        ist.insert(.init(interval: Fraction(12,14) ..< Fraction(16,4), value: []))
        XCTAssertEqual(root.value.max, Fraction(16,4))
    }

    func testIntervalNotContainedLessThan() {
        let searchInterval = Fraction(0,8) ..< Fraction(2,8)
        XCTAssertEqual(intervalTree.overlapping(searchInterval), [])
    }

    func testIntervalNotContainedGreaterThan() {
        let searchInterval = Fraction(14,8) ..< Fraction(16,8)
        XCTAssertEqual(intervalTree.overlapping(searchInterval), [])
    }

    func testIntervalContainsSingle() {
        let searchInterval = Fraction(11,8) ..< Fraction(13,8)
        let expected = [
            IntervalSearchTree<Fraction,Set<Int>>.Node(interval: Fraction(6,8) ..< Fraction(13,8), value: [])
        ]
        XCTAssertEqual(intervalTree.overlapping(searchInterval), expected)
    }

    func testIntervalContainsMultiple() {
        let searchInterval = Fraction(3,8) ..< Fraction(7,8)
        let expectedIntervals: [Range<Fraction>] = [
            Fraction(3,8) ..< Fraction(8,8),
            Fraction(2,8) ..< Fraction(9,8),
            Fraction(5,8) ..< Fraction(7,8),
            Fraction(6,8) ..< Fraction(13,8)
        ]
        let expected: [IntervalSearchTree<Fraction,Set<Int>>.Node] = expectedIntervals.map {
            .init(interval: $0, value: [])
        }
        let result = intervalTree.overlapping(searchInterval)
        XCTAssertEqual(result.count, expected.count)
        zip(result,expected).forEach { result,expected in
            XCTAssertEqual(result.interval, expected.interval)
        }
    }

    func testPointContainsMultiple() {
        let target = Fraction(8,8)
        let expectedIntervals: [Range<Fraction>] = [
            Fraction(2,8) ..< Fraction(9,8),
            Fraction(6,8) ..< Fraction(13,8)
        ]
        let expected: [IntervalSearchTree<Fraction,Set<Int>>.Node] = expectedIntervals.map {
            .init(interval: $0, value: [])
        }
        let result = intervalTree.containing(target)
        XCTAssertEqual(result, expected)
    }

    func testManyIntervalsOverlapping() {
        let intervals: [Range<Fraction>] = (0..<1_000_000).map { _ in
            let lowerBound = Fraction(Int.random(in: 1..<10_000),8)
            let length = Fraction(Int.random(in: 1..<10),8)
            let upperBound = lowerBound + length
            return lowerBound ..< upperBound
        }
        let payloads: [IntervalSearchTree<Fraction,Set<Int>>.Node] = intervals.map {
            .init(interval: $0, value: []) }
        let ist = IntervalSearchTree(payloads)
        let searchInterval = Fraction(40,8) ..< Fraction(300,8)
        let _ = ist.overlapping(searchInterval)
    }
}
