import XCTest

extension AVLTreeTests {
    static let __allTests = [
        ("testInitSequence", testInitSequence),
        ("testManyValuesDecreasing", testManyValuesDecreasing),
        ("testManyValuesIncreasing", testManyValuesIncreasing),
        ("testManyValuesRandom", testManyValuesRandom),
        ("testSingleNodeHeight", testSingleNodeHeight),
        ("testThreeNodes", testThreeNodes),
        ("testTwoNodes", testTwoNodes),
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
        ("testAddAttribute", testAddAttribute),
        ("testAddAttributeInInterval", testAddAttributeInInterval),
        ("testAddEntity", testAddEntity),
        ("testAddEventWithAttributes", testAddEventWithAttributes),
        ("testAddEventWithAttributesInInterval", testAddEventWithAttributesInInterval),
        ("testAddMeter", testAddMeter),
        ("testAddTempo", testAddTempo),
        ("testCreateEvent", testCreateEvent),
        ("testCreateEventInInterval", testCreateEventInInterval),
        ("testCreateEventWithEntities", testCreateEventWithEntities),
        ("testHelloWorld", testHelloWorld),
        ("testInferOffset", testInferOffset),
        ("testManyRhythms", testManyRhythms),
        ("testSingleNoteRhythm", testSingleNoteRhythm),
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
        testCase(AVLTreeTests.__allTests),
        testCase(MeterTempoTests.__allTests),
        testCase(ModelTests.__allTests),
        testCase(PerformanceContextTests.__allTests),
    ]
}
#endif
