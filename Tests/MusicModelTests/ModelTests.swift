//
//  ModelTests.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import XCTest
import DataStructures
import Math
import Pitch
import Articulations
import Duration
@testable import MusicModel

class ModelTests: XCTestCase {
    
    func testAddPitchArrayAttribute() {
        let pitches: Set<Pitch> = [60,61,62]
        let interval = Fraction(4,8)...Fraction(5,8)
        let model = Model.Builder()
            .add(pitches, label: "pitch", with: PerformanceContext.Path(), in: interval)
            .build()
        #warning("Add assertion to testAddPitchArrayAttribute()")
    }
    
    func testPitchesAndAtriculations() {
        let intervals = (0..<2).map { offset in Fraction(offset, 8)...Fraction(offset + 1, 8) }
        let pitches: [Pitch] = [60,61,62]
        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
        let articulations: [Articulation] = [.staccato, .accent, .tenuto]
        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
        let builder = Model.Builder()
        zip(events, intervals).forEach { event, interval in builder.add(event, in: interval) }
        let model = builder.build()
        print(model)
        #warning("Add assertion to testPitchesAndAtriculations()")
    }
    
    func testAddRhythm() {
        
        let rhythm = Rhythm<Int>(
            3/>16 * [1,2,3,1],
            [
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0))
            ]
        )
        
        let pitches: [Pitch] = [60,61,62,63]
        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
        let articulations: [Articulation] = [.staccato, .accent, .tenuto, .accent]
        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
        
        let model = Model.Builder()
            .add(rhythm, at: 0, with: events)
            .build()
        print(model)

        for rhythm in model.rhythms {
            print("RHYTHM:")
            for event in rhythm.events {
                let attributeIDs = model.events[event]!
                print(attributeIDs.map { model.values[$0] })
            }
        }

        #warning("Add assertion to testAddRhythm()")
    }
    
    func testAddManyRhythms() {

        let rhythm = Rhythm<Int>(
            1/>4 * [1,2,3,1],
            [
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0))
            ]
        )

        let pitches: [Pitch] = [60,61,62,63]
        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
        let articulations: [Articulation] = [.staccato, .accent, .tenuto, .accent]
        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
        
        let builder = Model.Builder()
        (0..<100).forEach { offsetBeats in
            builder.add(rhythm, at: Fraction(offsetBeats,4), with: events)
        }
    
        let model = builder.build()
        print(model)

        #warning("Add assertion to testAddManyRhythms()")
    }
    
    func testFilter() {
        
        let rhythm = Rhythm<Int>(
            1/>4 * [1,1,1,1],
            [
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0))
            ]
        )
        
        let context1 = PerformanceContext.Path("P", "I", 0)
        let context2 = PerformanceContext.Path("P", "II", 3)
        let pitches: [Pitch] = [60,61,62,63]
        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
        let articulations: [Articulation] = [.staccato, .accent, .tenuto, .accent]
        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
        
        let builder = Model.Builder()
        
        // Add a bunch of rhythms
        (0..<1000).forEach { offsetBeats in
            builder.add(rhythm, at: Fraction(offsetBeats,4), with: events, and: context1)
            builder.add(rhythm, at: Fraction(offsetBeats,4), with: events, and: context2)
        }
        
        // Construct the model
        let model = builder.build()

        let interval = Model.Filter(interval: Fraction(4,4)...Fraction(5/>4))
        let scope = Model.Filter(scope: PerformanceContext.Scope("P","I"))
        let label = Model.Filter(label: "articulation")
        let filter = [interval,scope,label].nonEmptyProduct!

        // Get the ids of all of the attributes within the given filter
        let filteredIDs = filter.apply(model)
        
        filteredIDs.forEach { id in
            let value = model.values[id]!
            let interval = model.intervals[id]!
            let context = model.performanceContexts[id]!
            print("\(value); interval: \(interval); contexts: \(context)")
        }

        #warning("Add assertion to testFilter()")
    }

    
    func testAddMeterStructure() {

        let builder = Model.Builder()
        
        for meter in [Meter(4,4), Meter(3,8), Meter(5,16), Meter(29,64), Meter(3,2)] {
            builder.add(meter)
        }

        builder.add(Tempo(90), at: .zero)
        builder.add(Tempo(60), at: Fraction(4,4), easing: .linear)
        builder.add(Tempo(120), at: Fraction(24,4))

        let model = builder.build()
        print(model)
        // TODO: Assert something!

        #warning("Add assertion to testAddMeterStructure()")
    }
}
