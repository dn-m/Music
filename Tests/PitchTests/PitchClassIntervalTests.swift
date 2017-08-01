//
//  PitchClassIntervalTests.swift
//  Pitch
//
//  Created by Jeremy Corren on 12/6/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import Pitch

class PitchClassIntervalTests: XCTestCase {
    
    func testInit() {
        let _: UnorderedInterval<Pitch.Class> = 2
        let _: OrderedInterval<Pitch.Class> = 2.0
    }
}
