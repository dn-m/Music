//
//  PitchDyadTests.swift
//  Pitch
//
//  Created by Jeremy Corren on 12/6/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
import Pitch

class PitchDyadTests: XCTestCase {
    
    func testInitOrdered() {
        let dyad = Dyad<Pitch>(Pitch(60.0), Pitch(62.0))
        XCTAssertEqual(dyad.lower, 60.0)
        XCTAssertEqual(dyad.higher, 62.0)
    }
    
    func testInterval() {
        let dyad = Dyad<Pitch>(Pitch(60.0), Pitch(62.0))
        XCTAssertEqual(dyad.interval, 2.0)
    }
    
    func testDescription() {
        let dyad = Dyad<Pitch>(Pitch(60.0), Pitch(62.0))
        XCTAssertEqual(dyad.description, "(60.0, 62.0)")
    }
    
    func testEqualityTrue() {
        let a: Dyad<Pitch> = .init(60,62)
        let b: Dyad<Pitch> = .init(60,62)
        XCTAssertEqual(a, b)
    }
    
    func testEqualityFalseHigherNotEqual() {
        let a: Dyad<Pitch> = .init(60,62)
        let b: Dyad<Pitch> = .init(60,63)
        XCTAssertNotEqual(a, b)
    }
    
    func testEqualityFalseLowerNotEqual() {
        let a: Dyad<Pitch> = .init(60,62)
        let b: Dyad<Pitch> = .init(59,62)
        XCTAssertNotEqual(a, b)
    }
    
    func testEqualityFalseNeitherEqual() {
        let a = Dyad<Pitch>(60,63)
        let b = Dyad<Pitch>(59,62)
        XCTAssertNotEqual(a, b)
    }
}
