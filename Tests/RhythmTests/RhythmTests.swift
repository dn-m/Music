//
//  RhythmTests.swift
//  RhythmTests
//
//  Created by James Bean on 6/18/18.
//

import XCTest
import MetricalDuration
import Rhythm

class RhythmTests: XCTestCase {
    
    func testUsage() {
        let durations = [1,2,3,4,1,1]
        let tree = 4/>8 * durations
        let leaves = durations.map { _ in event(1) }
        let rhythm = tree * leaves
    }
}
