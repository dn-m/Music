//
//  PerformanceContextTests.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/27/17.
//
//

import XCTest
import MusicModel

class PerformanceContextTests: XCTestCase {

    func testVoiceInit() {
        _ = Voice(4)
    }
    
    func testInstrumentInitEmpty() {
        _ = Instrument("VC", [])
    }
    
    func testInstrumentInitArrayOfVoiceIdentifiers() {
        
        let i = Instrument("VN", [1,4,5,6].map(Voice.init))
        XCTAssertEqual(i.count, 4)
        print(i)
    }
    
    func testPerformerInitArrayOfInstruments() {
        
        let i1 = Instrument("VOX", [1,2,3].map(Voice.init))
        let i2 = Instrument("DB", [1,2,3,4].map(Voice.init))
        let i3 = Instrument("FL", [1,4].map(Voice.init))
        let p = Performer("ABC", [i1, i2, i3])
        print(p)
    }

    func testPerformerHasInstrumentWithIdentifierTrue() {
        
        let i = Instrument("I", [0].map(Voice.init))
        let p = Performer("P", [i])
        XCTAssertNotNil(p.instruments["I"])
    }
    
    func testPerformerHasInstrumentWithIdentifierFalse() {
        
        let i = Instrument("I", [0].map(Voice.init))
        let p = Performer("P", [i])
        XCTAssertNil(p.instruments["J"])
    }
    
    func testContextContainsPathTrue() {
        let i = Instrument("I", [Voice(0)])
        let p = Performer("P", [i])
        let context = PerformanceContext(p)
        let path = PerformanceContext.Path("P", "I", 0)
        XCTAssert(context.contains(path))
    }
    
    func testContextContainsPathFalseWrongInstrument() {
        let i = Instrument("I", [Voice(0)])
        let p = Performer("P", [i])
        let context = PerformanceContext(p)
        let path = PerformanceContext.Path("P", "J", 0)
        XCTAssertFalse(context.contains(path))
    }
    
    func testContextContainsPathFalseWrongVoice() {
        let i = Instrument("I", [Voice(0)])
        let p = Performer("P", [i])
        let context = PerformanceContext(p)
        let path = PerformanceContext.Path("P", "I", 1)
        XCTAssertFalse(context.contains(path))
    }
    
    func testContextContainsPathFalseWrongVoiceAndInstrument() {
        let i = Instrument("I", [Voice(0)])
        let p = Performer("P", [i])
        let context = PerformanceContext(p)
        let path = PerformanceContext.Path("P", "J", 1)
        XCTAssertFalse(context.contains(path))
    }
    
//    func testContextIsInScopeFullyOpen() {
//        let context = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        let scope = PerformanceContext.Scope()
//        XCTAssert(scope.contains(context))
//        XCTAssert(context.isContained(by: scope))
//    }
//    
//    func testContextIsInScopePerformerSpecified() {
//        let context = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        let scope = PerformanceContext.Scope("P")
//        XCTAssert(scope.contains(context))
//        XCTAssert(context.isContained(by: scope))
//    }
//    
//    func testContextIsInScopePerformerSpecifiedFalse() {
//        let context = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        let scope = PerformanceContext.Scope("Q")
//        XCTAssertFalse(scope.contains(context))
//        XCTAssertFalse(context.isContained(by: scope))
//    }
//    
//    func testContextIsInScopePerformerAndInstrumentSpecified() {
//        let context = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        let scope = PerformanceContext.Scope("P", "I")
//        XCTAssert(scope.contains(context))
//        XCTAssert(context.isContained(by: scope))
//    }
//    
//    func testContextIsInScopePerformerAndInstrumentSpecifiedFalse() {
//        let context = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        let scope = PerformanceContext.Scope("P", "J")
//        XCTAssertFalse(scope.contains(context))
//        XCTAssertFalse(context.isContained(by: scope))
//    }
//    
//    func testContextIsInScopePerformerInstrumentAndVoiceSpecified() {
//        let context = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        let scope = PerformanceContext.Scope("P", "I", 0)
//        XCTAssert(scope.contains(context))
//        XCTAssert(context.isContained(by: scope))
//    }
//    
//    func testContextIsInScopePerformerInstrumentAndVoiceSpecifiedFalse() {
//        let context = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        let scope = PerformanceContext.Scope("P", "J", 1)
//        XCTAssertFalse(scope.contains(context))
//        XCTAssertFalse(context.isContained(by: scope))
//    }
}
