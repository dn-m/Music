import XCTest

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

extension PerformanceContextTests {
    static let __allTests = [
        ("testContextContainsPathFalseWrongInstrument", testContextContainsPathFalseWrongInstrument),
        ("testContextContainsPathFalseWrongVoice", testContextContainsPathFalseWrongVoice),
        ("testContextContainsPathFalseWrongVoiceAndInstrument", testContextContainsPathFalseWrongVoiceAndInstrument),
        ("testContextContainsPathTrue", testContextContainsPathTrue),
        ("testInstrumentInitArrayOfVoiceIdentifiers", testInstrumentInitArrayOfVoiceIdentifiers),
        ("testInstrumentInitEmpty", testInstrumentInitEmpty),
        ("testPerformerHasInstrumentWithIdentifierFalse", testPerformerHasInstrumentWithIdentifierFalse),
        ("testPerformerHasInstrumentWithIdentifierTrue", testPerformerHasInstrumentWithIdentifierTrue),
        ("testPerformerInitArrayOfInstruments", testPerformerInitArrayOfInstruments),
        ("testVoiceInit", testVoiceInit),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MeterTempoTests.__allTests),
        testCase(ModelTests.__allTests),
        testCase(PerformanceContextTests.__allTests),
    ]
}
#endif
