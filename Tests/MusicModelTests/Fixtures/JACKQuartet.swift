//
//  JACKQuartet.swift
//  MusicModelTests
//
//  Created by James Bean on 9/13/18.
//

import MusicModel

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

// Voicess
let chrisVoice0 = Voice(name: "Chris - ViolinI - 0")
let chrisVoice1 = Voice(name: "Chris - ViolinI - 1")
let chrisVoice2 = Voice(name: "Chris - ViolinI - 2")
let austinVoice0 = Voice(name: "Austin - ViolinII - 0")
let johnVoice0 = Voice(name: "John - Viola - 0")
let jayVoice0 = Voice(name: "Jay - Violoncello - 0")

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
    builder.addVoice(chrisVoice0, performer: chris, instrument: violinI)
    builder.addVoice(chrisVoice1, performer: chris, instrument: violinI)
    builder.addVoice(chrisVoice2, performer: chris, instrument: violinI)
    builder.addVoice(austinVoice0, performer: austin, instrument: violinII)
    builder.addVoice(johnVoice0, performer: john, instrument: viola)
    builder.addVoice(jayVoice0, performer: jay, instrument: violoncello)
    return builder.build()
}
