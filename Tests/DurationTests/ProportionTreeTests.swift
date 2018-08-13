//
//  ProportionTreeTests.swift
//  Rhythm
//
//  Created by James Bean on 2/2/17.
//
//

import XCTest
import DataStructures
import Math
@testable import Duration

class ProportionTreeTests: XCTestCase {

    var veryNested: Tree<Int,Int> {
        return Tree.branch(1, [
            .branch(2, [
                .branch(16, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(24)
            ]),
            .branch(4, [
                .leaf(3),
                .leaf(4),
                .branch(6, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(2),
                .branch(2, [
                    .leaf(3),
                    .leaf(5)
                ])
            ]),
            .branch(3, [
                .leaf(2),
                .leaf(4),
                .branch(1, [
                    .leaf(32),
                    .leaf(34)
                ])
            ])
        ])
    }

    func testInit() {
        _ = Tree.branch(1, [.leaf(1), .leaf(2), .leaf(2)])
    }

    func testReducedSingleDepth() {
        let tree = Tree.branch(1, [
            .leaf(2),
            .leaf(4),
            .leaf(6)
        ])
        XCTAssertEqual(tree.reducingSiblings.leaves, [1,2,3])
    }

    func testReducedNested() {
        let tree = Tree.branch(1, [
            .leaf(2),
            .branch(4, [
                .leaf(6),
                .leaf(2),
                .leaf(4)
            ]),
            .leaf(8)
        ])
        XCTAssertEqual(tree.reducingSiblings.leaves, [1,3,1,2,4])
    }

    func testReducedVeryNested() {
        let result = veryNested.reducingSiblings
        let expected = Tree.branch(1, [
            .branch(2, [
                .branch(2, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(3)
            ]),
            .branch(4, [
                .leaf(3),
                .leaf(4),
                .branch(6, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(2),
                .branch(2, [
                    .leaf(3),
                    .leaf(5)
                ])
            ]),
            .branch(3, [
                .leaf(2),
                .leaf(4),
                .branch(1, [
                    .leaf(16),
                    .leaf(17)
                ])
            ])
        ])
        XCTAssertEqual(result, expected)
    }

    func testmatchingParentsToChildrenSingleDepthDownTwo() {
        let tree = Tree.branch(6, [.leaf(1), .leaf(1)])
        XCTAssertEqual(tree.matchingParentsToChildren.value, 3)
    }

	func testmatchingParentsToChildrenSingleDepthDownThree() {
		let tree = Tree.branch(6, [.leaf(1),.leaf(2)])
		XCTAssertEqual(tree.matchingParentsToChildren.value, 3)
	}

    func testmatchingParentsToChildrenSingleDepthUp() {
        let tree = Tree.branch(1, [.leaf(8),.leaf(3)])
        XCTAssertEqual(tree.matchingParentsToChildren.value, 8)
    }

    func testMatchParentsVeryNestedMultipleCases() {
        let result = veryNested.reducingSiblings.matchingParentsToChildren
        let expected = Tree.branch(8, [
            .branch(4, [
                .branch(2, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(3)
            ]),
            .branch(16, [
                .leaf(3),
                .leaf(4),
                .branch(3, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(2),
                .branch(8, [
                    .leaf(3),
                    .leaf(5)
                ])
            ]),
            .branch(6, [
                .leaf(2),
                .leaf(4),
                .branch(32, [
                    .leaf(16),
                    .leaf(17)
                ])
            ])
        ])
        XCTAssertEqual(result, expected)
    }

    func testNormalizeVeryNested() {
        let expected = Tree.branch(512, [
            .branch(128, [
                .branch(64, [
                    .leaf(32),
                    .leaf(32)
                ]),
                .leaf(96)
            ]),
            .branch(256, [
                .leaf(48),
                .leaf(64),
                .branch(96, [
                    .leaf(32),
                    .leaf(32)
                ]),
                .leaf(32),
                .branch(32, [
                    .leaf(12),
                    .leaf(20)
                ])
            ]),
            .branch(192, [
                .leaf(64),
                .leaf(128),
                .branch(32, [
                    .leaf(16),
                    .leaf(17)
                ])
            ])
        ])
        let result = veryNested.normalized
        XCTAssertEqual(result, expected)
    }

    func testNormalizedNested() {
        let tree = Tree.branch(1, [
            .branch(2, [
                .leaf(3),
                .leaf(2)
            ]),
            .leaf(4),
            .branch(3, [
                .leaf(2),
                .branch(4, [
                    .leaf(4),
                    .leaf(3)
                ]),
                .leaf(1)
            ])
        ])
        let expected = Tree.branch(32, [
            .branch(8, [
                .leaf(6),
                .leaf(4)
            ]),
            .leaf(16),
            .branch(12, [
                .leaf(4),
                .branch(8, [
                    .leaf(4),
                    .leaf(3)
                ]),
                .leaf(2)
            ])
        ])
        XCTAssertEqual(tree.normalized, expected)
    }

    func testNormalizeSingleDepth() {
        let tree = Tree.branch(5, [.leaf(1), .leaf(1)])
        XCTAssertEqual(tree.normalized.leaves, [2,2])
    }

    func testNormalizeSingleDepthBranchOfSingleLeafOf3() {
        let tree = Tree.branch(3, [.leaf(3)])
        let normalizedTree = tree.normalized
        XCTAssertEqual(tree, normalizedTree)
    }

    func testScaleSimple() {
        let tree = ProportionTree(1,[1,1,1])
        let value = Fraction(2,3)
        let expected = Tree<Fraction,Fraction>.branch(1, [
            .leaf(value),
            .leaf(value),
            .leaf(value)
        ])
        XCTAssertEqual(tree.scaling, expected)
    }
}
