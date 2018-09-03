//
//  AVLTreeTests.swift
//  MusicModelTests
//
//  Created by James Bean on 9/2/18.
//

import XCTest
import DataStructures
@testable import MusicModel

class AVLTreeTests: XCTestCase {

    func testInitSequence() {
        let tree: AVLTree = [(3,"d"),(1,"b"),(2,"c"),(0,"a")]
        dump(tree.inOrder)
    }

    func testSingleNodeHeight() {
        let tree: AVLTree = [(0,"0")]
        let expected = AVLTree(root: AVLTree.Node(key: 0, value: "0"))
        XCTAssertEqual(tree, expected)
    }

    func testTwoNodes() {
        let tree: AVLTree = [(0,"0"),(1,"1")]
        let child = AVLTree.Node(key: 1, value: "1", height: 1)
        let parent = AVLTree.Node(key: 0, value: "0", height: 2)
        parent.right = child
        let expected = AVLTree(root: parent)
        XCTAssertEqual(tree, expected)
    }

    func testThreeNodes() {
        let tree: AVLTree = [(0,"0"),(1,"1"),(2,"2")]
        let left = AVLTree.Node(key: 0, value: "0", height: 2)
        let parent = AVLTree.Node(key: 1, value: "1", height: 1)
        let right = AVLTree.Node(key: 2, value: "2", height: 1)
        parent.left = left
        parent.right = right
        let expected = AVLTree(root: parent)
        XCTAssertEqual(tree, expected)
    }

    func testManyValuesIncreasing() {
        let values = (0..<100_000).map { ($0,$0) }
        measure {
            let _ = AVLTree(values)
        }
    }

    func testManyValuesDecreasing() {
        let values = (0..<100_000).reversed().map { ($0,$0) }
        measure {
            let _ = AVLTree(values)
        }
    }


    func testManyValuesRandom() {
        let values = (0..<1_000_000).map { ($0,$0) }.shuffled()
        let _ = AVLTree(values)
    }
}
