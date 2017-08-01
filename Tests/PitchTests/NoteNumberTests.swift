//
//  NoteNumberTests.swift
//  Pitch
//
//  Created by James Bean on 5/7/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import XCTest
@testable import Pitch

class NoteNumberTests: XCTestCase {

    func testRandom() {
        let nn: NoteNumber = NoteNumber.random()
        XCTAssert(nn.value >= 60 && nn.value <= 72)
    }
    
    func testNoteNumberInit() {
        let _: NoteNumber = 60.0
        let _ = NoteNumber(floatLiteral: 60.0)
        let _ = NoteNumber(440.0)
    }
    
    func testQuantizedFromEighthToQuarterStep() {
        let nn: NoteNumber = 60.75
        XCTAssertEqual(nn.quantized(to: 0.5), 61)
    }
    
    func testQuantizedFromArbitraryToEighthStep() {
        let nn: NoteNumber = 60.298567
        XCTAssertEqual(nn.quantized(to: 0.25), 60.25)
    }
    
    func testQuantizedFromArbitraryToQuarterStep() {
        let nn: NoteNumber = 60.298567
        XCTAssertEqual(nn.quantized(to: 0.5), 60.5)
    }
    
    func testQuantizedFromArbitraryToWholeStep() {
        let nn: NoteNumber = 60.298567
        XCTAssertEqual(nn.quantized(to: 1), 60)
    }
}
