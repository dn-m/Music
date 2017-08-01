//
//  PitchClassSetTests.swift
//  Pitch
//
//  Created by Jeremy Corren on 12/8/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import Pitch

class PitchClassSetTests: XCTestCase {
    
    func testEquality() {
        let pcSet1: Set<Pitch.Class> = [0,1,6]
        let pcSet2: Set<Pitch.Class> = [0,1,6]
        XCTAssert(pcSet1 == pcSet2)
    }
}
