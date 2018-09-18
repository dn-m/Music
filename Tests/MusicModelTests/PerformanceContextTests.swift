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

    func testInitEmpty() {
        let _ = PerformanceContext.Builder()
    }

    func testAddVoice() {
        let performer = Performer(name: "Jill")
        let instrument = Instrument(name: "Bass Saxophone")
        let builder = PerformanceContext.Builder()
        _ = builder.addVoice(performer: performer, instrument: instrument)
    }

    func testBuilder() {
        let expected = PerformanceContext(
            performerByID: [0: john, 1: austin, 2: chris, 3: jay],
            instrumentByID: [0: violinI, 1: violinII, 2: viola, 3: violoncello],
            voiceByID: [
                0: chrisVoice0,
                1: chrisVoice1,
                2: chrisVoice2,
                3: austinVoice0,
                4: johnVoice0,
                5: jayVoice0
            ],
            performerInstrumentVoices: [
                .init(performerInstrument: PerformerInstrument(2,0), voice: 0),
                .init(performerInstrument: PerformerInstrument(2,0), voice: 1),
                .init(performerInstrument: PerformerInstrument(2,0), voice: 2),
                .init(performerInstrument: PerformerInstrument(1,1), voice: 3),
                .init(performerInstrument: PerformerInstrument(0,2), voice: 4),
                .init(performerInstrument: PerformerInstrument(3,3), voice: 5),
            ]
        )
        XCTAssertEqual(jackQuartet,expected)
    }

    func testFilterPerformers() {
        let violinsOnlyFilter = PerformanceContext.Filter(performers: [chris,austin])
        let violinsOnly = jackQuartet.filtered(by: violinsOnlyFilter)
        let expected = PerformanceContext(
            performerByID: [1: austin, 2: chris],
            instrumentByID: [0: violinI, 1: violinII],
            voiceByID: [
                0: chrisVoice0,
                1: chrisVoice1,
                2: chrisVoice2,
                3: austinVoice0,
            ],
            performerInstrumentVoices: [
                .init(performerInstrument: PerformerInstrument(2,0), voice: 0),
                .init(performerInstrument: PerformerInstrument(2,0), voice: 1),
                .init(performerInstrument: PerformerInstrument(2,0), voice: 2),
                .init(performerInstrument: PerformerInstrument(1,1), voice: 3),
            ]
        )
        XCTAssertEqual(violinsOnly,expected)
    }

    func testFilterInstruments() {
        let violinsOnlyFilter = PerformanceContext.Filter(instruments: [violinI,violinII])
        let violinsOnly = jackQuartet.filtered(by: violinsOnlyFilter)
        let expected = PerformanceContext(
            performerByID: [1: austin, 2: chris],
            instrumentByID: [0: violinI, 1: violinII],
            voiceByID: [
                0: chrisVoice0,
                1: chrisVoice1,
                2: chrisVoice2,
                3: austinVoice0,
            ],
            performerInstrumentVoices: [
                .init(performerInstrument: PerformerInstrument(2,0), voice: 0),
                .init(performerInstrument: PerformerInstrument(2,0), voice: 1),
                .init(performerInstrument: PerformerInstrument(2,0), voice: 2),
                .init(performerInstrument: PerformerInstrument(1,1), voice: 3),
            ]
        )
        XCTAssertEqual(violinsOnly,expected)
    }

    func testFilterVoices() {
        let violinsOnlyFilter = PerformanceContext.Filter(
            voices: [
                chrisVoice0,
                chrisVoice2,
                jayVoice0
            ]
        )
        let violinsOnly = jackQuartet.filtered(by: violinsOnlyFilter)
        let expected = PerformanceContext(
            performerByID: [2: chris, 3: jay],
            instrumentByID: [0: violinI, 3: violoncello],
            voiceByID: [
                0: chrisVoice0,
                2: chrisVoice2,
                5: jayVoice0
            ],
            performerInstrumentVoices: [
                .init(performerInstrument: PerformerInstrument(2,0), voice: 0),
                .init(performerInstrument: PerformerInstrument(2,0), voice: 2),
                .init(performerInstrument: PerformerInstrument(3,3), voice: 5),
            ]
        )
        XCTAssertEqual(violinsOnly,expected)
    }

    func testFilterPerformersAndVoices() {
        let violinsOnlyFilter = PerformanceContext.Filter(
            performers: [chris],
            voices: [jayVoice0]
        )
        let violinsOnly = jackQuartet.filtered(by: violinsOnlyFilter)
        let expected = PerformanceContext(
            performerByID: [2: chris, 3: jay],
            instrumentByID: [0: violinI, 3: violoncello],
            voiceByID: [
                0: chrisVoice0,
                1: chrisVoice1,
                2: chrisVoice2,
                5: jayVoice0
            ],
            performerInstrumentVoices: [
                .init(performerInstrument: PerformerInstrument(2,0), voice: 0),
                .init(performerInstrument: PerformerInstrument(2,0), voice: 1),
                .init(performerInstrument: PerformerInstrument(2,0), voice: 2),
                .init(performerInstrument: PerformerInstrument(3,3), voice: 5),
            ]
        )
        XCTAssertEqual(violinsOnly,expected)
    }
}
