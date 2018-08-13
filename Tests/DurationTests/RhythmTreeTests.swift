//
//  RhythmTreeTests.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import XCTest
import DataStructures
import Duration

class RhythmTreeTests: XCTestCase {

    func testInit() {
        let metricalDurationTree = 1/>8 * [1,2,3]
        let contexts: [MetricalContext<Int>] = [
            .instance(.event(1)),
            .continuation,
            .instance(.absence)
        ]
        _ = metricalDurationTree * contexts
    }
}
