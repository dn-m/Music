//
//  ChordTests.swift
//  PitchTests
//
//  Created by James Bean on 10/9/18.
//

import XCTest
@testable import Pitch

class ChordTests: XCTestCase {

    func testInitAPI() {
        let _ = Chord(60, [4,3])
    }
}
