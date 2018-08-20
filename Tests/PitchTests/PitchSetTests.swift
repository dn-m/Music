//
//  PitchSetTests.swift
//  Pitch
//
//  Created by James Bean on 5/17/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import Pitch

class PitchSetTests: XCTestCase {

    func testDyads() {
        let set: Set<Pitch> = [60, 61, 62, 63]
        XCTAssertEqual(set.dyads.count, 6)
    }
    
    func testPitchClassSet() {
        let pitchSet: Set<Pitch> = [63.5, 69.25]
        let pcs = Set(pitchSet.map { $0.class })
        let pcs2: Set<Pitch.Class> = [3.5,9.25]
        XCTAssertEqual(pcs, pcs2)
    }

//    func testInitPitchSetUnion() {
//        let pitchSet1: Set<Pitch> = [60, 61]
//        let pitchSet2: Set<Pitch> = [62, 63]
//        let new = Set<Pitch>(pitchSet1, pitchSet2)
//        XCTAssertEqual(new, [60, 61, 62, 63])
//    }

//    func testFormUnion() {
//        let pitchSet1: Set<Pitch> = [60, 61]
//        let pitchSet2: Set<Pitch> = [62, 63]
//        let new = pitchSet1.formUnion(with: pitchSet2)
//        XCTAssertEqual(new, [60, 61, 62, 63])
//    }

//    func testArrayLiteralConvertible() {
//        let _: Set<Pitch> = [60.0, 61.0]
//    }
//    
//    func testInitWithPitchSetsEmpty() {
//        let pitchSets: [Set<Pitch>] = []
//        let pitchSet = Set<Pitch>(pitchSets)
//        XCTAssert(pitchSet.isEmpty)
//    }
//    
//    func testInitWithPitchSetsSingle() {
//        let pitchSets = [Set<Pitch>([60])]
//        let pitchSet = Set<Pitch>(pitchSets)
//        XCTAssertEqual(pitchSet, Set<Pitch>([60]))
//    }
//    
//    func testInitWithPitchSetsMultipleOverlapping() {
//        let pitchSets = [Set<Pitch>([60]), Set<Pitch>([60,61]), Set<Pitch>([65])]
//        let pitchSet = Set<Pitch>(pitchSets)
//        XCTAssertEqual(pitchSet, Set<Pitch>([60,61,65]))
//    }
}
