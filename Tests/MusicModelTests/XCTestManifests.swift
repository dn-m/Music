import XCTest

extension IntervalSearchTreeTests {
    static let __allTests = [
        ("testInsertMaxUpdated", testInsertMaxUpdated),
        ("testIntervalContainsMultiple", testIntervalContainsMultiple),
        ("testIntervalContainsSingle", testIntervalContainsSingle),
        ("testIntervalNotContainedGreaterThan", testIntervalNotContainedGreaterThan),
        ("testIntervalNotContainedLessThan", testIntervalNotContainedLessThan),
        ("testManyIntervalsOverlapping", testManyIntervalsOverlapping),
        ("testPointContainsMultiple", testPointContainsMultiple),
    ]
}

extension MeterTempoTests {
    static let __allTests = [
        ("testMeterBeatOffsets", testMeterBeatOffsets),
        ("testTempoDurationAt30", testTempoDurationAt30),
        ("testTempoDurationAt60", testTempoDurationAt60),
        ("testTempoDurationAt90", testTempoDurationAt90),
        ("testTempoDurationForBeatAtSubdivisionLevelDoubleAt60", testTempoDurationForBeatAtSubdivisionLevelDoubleAt60),
        ("testTempoDurationForBeatAtSubdivisionLevelHalfAt90", testTempoDurationForBeatAtSubdivisionLevelHalfAt90),
        ("testTempoDurationForBeatAtSubdivisionLevelSameAt60", testTempoDurationForBeatAtSubdivisionLevelSameAt60),
        ("testTempoInit", testTempoInit),
    ]
}

extension ModelTests {
    static let __allTests = [
        ("testAddMeter", testAddMeter),
        ("testAddTempo", testAddTempo),
        ("testHelloWorld", testHelloWorld),
        ("testInferOffset", testInferOffset),
        ("testManyRhythms", testManyRhythms),
        ("testSingleNoteRhythm", testSingleNoteRhythm),
        ("testSlur", testSlur),
    ]
}

extension PerformanceContextTests {
    static let __allTests = [
        ("testAddVoice", testAddVoice),
        ("testInitEmpty", testInitEmpty),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(IntervalSearchTreeTests.__allTests),
        testCase(MeterTempoTests.__allTests),
        testCase(ModelTests.__allTests),
        testCase(PerformanceContextTests.__allTests),
    ]
}
#endif
