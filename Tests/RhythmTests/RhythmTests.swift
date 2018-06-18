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
        let tree = 4/>8 * [1,2,3,4,1,1]
        let leaves: [MetricalContext<()>] = [
            .instance(.event(())),
            .instance(.event(())),
            .instance(.event(())),
            .instance(.event(())),
            .instance(.event(())),
            rest()
        ]
        let rhythm = tree * leaves
    }
}
