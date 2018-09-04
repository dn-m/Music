//
//  PerformanceContextTests.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/27/17.
//
//

import XCTest
@testable import MusicModel

class PerformanceContextTests: XCTestCase {

    // MARK: Builder

    func testInitEmpty() {
        let _ = PerformanceContext.Builder()
    }

    func testAddVoice() {
        let performer = Performer(name: "Jill")
        let instrument = Instrument(name: "Bass Saxophone")
        let builder = PerformanceContext.Builder()
        builder.addVoice(forPerformer: performer, withInstrument: instrument)
        //let pair = PerformerInstrumentPair(performer: performer, instrument: instrument)
        //XCTAssertEqual(builder.voices, [pair: [0]])
        dump(builder.voices)
    }

    
}
