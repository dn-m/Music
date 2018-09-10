//
//  DurationTreeTests.swift
//  Rhythm
//
//  Created by James Bean on 2/10/17.
//
//

import XCTest
import DataStructures
import Math
import Duration

class DurationTreeTests: XCTestCase {

    func testInitSubdivisionAndProportionTree() {
        let result = DurationTree(16, ProportionTree(1, [1,2,3]))
        let expected = DurationTree.branch(4/>16, [
            .leaf(1/>16),
            .leaf(2/>16),
            .leaf(3/>16)
        ])
        XCTAssertEqual(result, expected)
    }

    func testInitSubdivisionOperator() {
        let result = DurationTree(16, ProportionTree(1,[1,2,3]))
        let expected = DurationTree.branch(4/>16, [
            .leaf(1/>16),
            .leaf(2/>16),
            .leaf(3/>16)
        ])
        XCTAssertEqual(result, expected)
    }

    func testInitDuration() {
        let proportionTree: ProportionTree = .branch(1, [
            .branch(1, [.leaf(1), .leaf(1), .leaf(1)]),
            .leaf(2),
            .leaf(3)
        ])
        let result = DurationTree(5/>32, proportionTree)
        let expected = DurationTree.branch(10/>64, [
            .branch(2/>64, [
                .leaf(1/>64),
                .leaf(1/>64),
                .leaf(1/>64)
            ]),
            .leaf(4/>64),
            .leaf(6/>64)
        ])
        XCTAssertEqual(result, expected)
    }

    func testInitDurationProportionTreeOperator() {
        let result = DurationTree(17/>64, ProportionTree(1,[1,2,3]))
        let expected = DurationTree.branch(17/>64, [
            .leaf(2/>64),
            .leaf(4/>64),
            .leaf(6/>64)
        ])
        XCTAssertEqual(result, expected)
    }

    func testInitEmptyArray() {
        let tree = 3/>16 * []

        guard case .branch(let duration, let trees) = tree else {
            XCTFail()
            return
        }

        XCTAssertEqual(duration, 3/>16)
        XCTAssertEqual(trees.count, 1)
        XCTAssertEqual(trees.first!.duration, 3/>16)
    }

    func testSingleLeaf() {
        let tree = 1/>8 * [1]
        XCTAssertEqual(tree.leaves.count, 1)
    }

    func testMultipleLeaves() {
        let tree = 1/>8 * [1,2,3,4]
        XCTAssertEqual(tree.leaves.count, 4)
    }

    func testInitWithRelativeDurations() {

        let tree = 1/>8 * [1,2,3,4,1]

        guard case .branch(let duration, _) = tree else {
            XCTFail()
            return
        }

        XCTAssertEqual(duration, 8/>64)
    }

    func testInitWithRelativeDurations13Over12() {

        let tree = 3/>16 * [2,4,3,2,2]

        guard case .branch(let duration, _) = tree else {
            XCTFail()
            return
        }

        XCTAssertEqual(duration, 12/>64)
    }

    func testInitWithRelativeDurations4Over5() {

        let tree = 5/>8 * [1,1]

        guard case .branch(_, let trees) = tree else {
            XCTFail()
            return
        }

        XCTAssertEqual(trees.map { $0.duration }, [2/>8, 2/>8])
    }

    func testInitWithRelativeDurations5Over4() {

        let tree = 8/>64 * [2,2,1]

        guard case .branch(let duration, _) = tree else {
            XCTFail()
            return
        }

        XCTAssertEqual(duration, 8/>64)
    }

    func testLeafOffsets() {
        let tree = 1/>8 * [1,1,1]
        XCTAssertEqual(tree.offsets, [Fraction(0,1), Fraction(1,24), Fraction(1,12)])
    }

    func testManyDurationTrees() {
        (0..<10_000).forEach { _ in
            let _ = DurationTree(16, ProportionTree(1,[1,2,3]))
        }
    }
}
