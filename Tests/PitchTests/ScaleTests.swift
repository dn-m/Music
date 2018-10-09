//
//  ScaleTests.swift
//  PitchTests
//
//  Created by James Bean on 10/9/18.
//

import XCTest
@testable import Pitch

class ScaleTests: XCTestCase {

    func testInitAPI() {
        let _ = Scale(60, [2,1,2,1,2,1,2,1])
    }

    func testMajor() {
        let _ = Scale(60, .major)
    }

    func testMelodicMinor() {
        let _ = Scale(66, .melodicMinorAscending)
        let _ = Scale(66, .melodicMinorDescending)
    }
}
