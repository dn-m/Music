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

    func testNoteNumberInit() {
        let _: NoteNumber = 60.0
        let _ = NoteNumber(floatLiteral: 60.0)
        let _ = NoteNumber(440.0)
    }
}
