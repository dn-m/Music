//
//  PitchIntervalTests.swift
//  Pitch
//
//  Created by Jeremy Corren on 12/6/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import Pitch

class PitchIntervalTests: XCTestCase {
    
    func testInit() {
        let _ = UnorderedInterval<Pitch>(noteNumber: 12.0)
        let _: UnorderedInterval<Pitch> = 12
        let _: UnorderedInterval<Pitch> = 12.0
    }
    
    func testEquatable() {
        let a: UnorderedInterval<Pitch> = .init(48, 51)
        let b: UnorderedInterval<Pitch> = .init(48, 51)
        XCTAssertEqual(a, b)
    }
}
