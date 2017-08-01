//
//  PitchClassDyadTests.swift
//  Pitch
//
//  Created by Jeremy Corren on 12/7/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import Pitch

class PitchClassDyadTests: XCTestCase {

    func testOrderedIntervalEasy() {
        let pcDyad = Dyad<Pitch.Class>(Pitch.Class(3.0), Pitch.Class(7.0))
        XCTAssertEqual(pcDyad.interval, 4.0)
    }

    func testOrderedIntervalCrossOver() {
        let _ = Dyad<Pitch.Class>(Pitch.Class(3.0), Pitch.Class(7.0))
    }

    func testEquality() {
        let a: Dyad<Pitch.Class> = Dyad(3,7)
        let b: Dyad<Pitch.Class> = Dyad(3,7)
        XCTAssertEqual(a, b)
    }
    
    func testEqualityNotEqual() {
        let a = Dyad<Pitch.Class>(3,7)
        let b = Dyad<Pitch.Class>(2,9)
        XCTAssertNotEqual(a, b)
    }
}
