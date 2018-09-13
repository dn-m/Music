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

    // Performers
    let john = Performer(name: "John")
    let austin = Performer(name: "Austin")
    let chris = Performer(name: "Chris")
    let jay = Performer(name: "Jay")

    // Instruments
    let violinI = Instrument(name: "Violin I")
    let violinII = Instrument(name: "Violin II")
    let viola = Instrument(name: "Viola")
    let violoncello = Instrument(name: "Violoncello")

    var jackQuartet: PerformanceContext {


        let builder = PerformanceContext.Builder()
        // Add performers
        builder.addPerformer(john)
        builder.addPerformer(austin)
        builder.addPerformer(chris)
        builder.addPerformer(jay)
        // Add instruments
        builder.addInstrument(violinI)
        builder.addInstrument(violinII)
        builder.addInstrument(viola)
        builder.addInstrument(violoncello)
        // Add voices
        // Make Chris play three lines at once
        builder.addVoice(Voice(name: "Chris - ViolinI - 0"), performer: chris, instrument: violinI)
        builder.addVoice(Voice(name: "Chris - ViolinI - 1"), performer: chris, instrument: violinI)
        builder.addVoice(Voice(name: "Chris - ViolinI - 2"), performer: chris, instrument: violinI)
        builder.addVoice(Voice(name: "Austin - ViolinII - 0"), performer: austin, instrument: violinII)
        builder.addVoice(Voice(name: "John - Viola - 0"), performer: john, instrument: viola)
        builder.addVoice(Voice(name: "Jay - Violoncello - 0"), performer: jay, instrument: violoncello)
        return builder.build()
    }

    func testBuilder() {
        let expected = PerformanceContext(
            performerByID: [0: john, 1: austin, 2: chris, 3: jay],
            instrumentByID: [0: violinI, 1: violinII, 2: viola, 3: violoncello],
            voiceByID: [
                0: Voice(name: "Chris - ViolinI - 0"),
                1: Voice(name: "Chris - ViolinI - 1"),
                2: Voice(name: "Chris - ViolinI - 2"),
                3: Voice(name: "Austin - ViolinII - 0"),
                4: Voice(name: "John - Viola - 0"),
                5: Voice(name: "Jay - Violoncello - 0")
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
                0: Voice(name: "Chris - ViolinI - 0"),
                1: Voice(name: "Chris - ViolinI - 1"),
                2: Voice(name: "Chris - ViolinI - 2"),
                3: Voice(name: "Austin - ViolinII - 0"),
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
                0: Voice(name: "Chris - ViolinI - 0"),
                1: Voice(name: "Chris - ViolinI - 1"),
                2: Voice(name: "Chris - ViolinI - 2"),
                3: Voice(name: "Austin - ViolinII - 0"),
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
                Voice(name: "Chris - ViolinI - 0"),
                Voice(name: "Chris - ViolinI - 2"),
                Voice(name: "Jay - Violoncello - 0")
            ]
        )
        let violinsOnly = jackQuartet.filtered(by: violinsOnlyFilter)
        let expected = PerformanceContext(
            performerByID: [2: chris, 3: jay],
            instrumentByID: [0: violinI, 3: violoncello],
            voiceByID: [
                0: Voice(name: "Chris - ViolinI - 0"),
                2: Voice(name: "Chris - ViolinI - 2"),
                5: Voice(name: "Jay - Violoncello - 0")
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
            voices: [Voice(name: "Jay - Violoncello - 0")]
        )
        let violinsOnly = jackQuartet.filtered(by: violinsOnlyFilter)
        let expected = PerformanceContext(
            performerByID: [2: chris, 3: jay],
            instrumentByID: [0: violinI, 3: violoncello],
            voiceByID: [
                0: Voice(name: "Chris - ViolinI - 0"),
                1: Voice(name: "Chris - ViolinI - 1"),
                2: Voice(name: "Chris - ViolinI - 2"),
                5: Voice(name: "Jay - Violoncello - 0")
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
