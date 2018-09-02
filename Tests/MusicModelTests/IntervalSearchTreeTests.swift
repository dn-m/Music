//
//  IntervalSearchTreeTests.swift
//  MusicModelTests
//
//  Created by James Bean on 9/2/18.
//

import XCTest
@testable import MusicModel

class IntervalSearchTreeTests: XCTestCase {

    func testInitSequence() {
        let ist: IntervalSearchTree = [("a", 1..<5), ("b", 3..<7), ("c", 6..<13)]
        let inOrder = ist.inOrder
        let expected: [(String,Range<Int>)] = [("a", 1..<5), ("b", 3..<7), ("c", 6..<13)]
        XCTAssertEqual(inOrder.count, expected.count)
        zip(inOrder.map { ($0.value, $0.interval) },expected).forEach { inOrder, expected in
            XCTAssertEqual(inOrder.0,expected.0)
            XCTAssertEqual(inOrder.1,expected.1)
        }
    }

    func testSubtreeMax() {
        // Example from: https://www.geeksforgeeks.org/interval-tree/
        let ist: IntervalSearchTree = [
            (3, 15..<20), (1, 10..<30), (0, 5..<20), (2, 12..<15), (4, 17..<19), (5, 30..<40)
        ]
        let expected: IntervalSearchTree = .branch(
            .branch(
                .leaf(.init(value: 0, interval: 5..<20, max: 20)),
                .init(value: 1, interval: 10..<30, max: 30),
                .leaf(.init(value: 2, interval: 12..<15, max: 15))
            ),
            .init(value: 3, interval: 15..<20, max: 40),
            .branch(
                .empty,
                .init(value: 4, interval: 17..<19, max: 40),
                .leaf(.init(value: 5, interval: 30..<40, max: 40))
            )
        )
        XCTAssertEqual(ist, expected)
    }

    
}
