import XCTest

extension EasingEvaluateTests {
    static let __allTests = [
        ("testLinear", testLinear),
        ("testPowerInHalf", testPowerInHalf),
        ("testPowerInOne", testPowerInOne),
        ("testPowerInOutOne", testPowerInOutOne),
        ("testPowerInOutThree", testPowerInOutThree),
        ("testPowerInOutTwo", testPowerInOutTwo),
        ("testPowerInTwo", testPowerInTwo),
        ("testSineInOut", testSineInOut),
    ]
}

extension EasingIntegrateTests {
    static let __allTests = [
        ("testLinear", testLinear),
        ("testPowerInHalf", testPowerInHalf),
        ("testPowerInOne", testPowerInOne),
        ("testPowerInOutOne", testPowerInOutOne),
        ("testPowerInOutThree", testPowerInOutThree),
        ("testPowerInOutTwo", testPowerInOutTwo),
        ("testPowerInTwo", testPowerInTwo),
        ("testSineInOut", testSineInOut),
    ]
}

extension StratumTests {
    static let __allTests = [
        ("testBuilderMultipleStatic", testBuilderMultipleStatic),
        ("testBuilderSingleInterpolation", testBuilderSingleInterpolation),
        ("testBuilderSingleStatic", testBuilderSingleStatic),
        ("testFragment", testFragment),
        ("testMoreComplexFragment", testMoreComplexFragment),
        ("testSimpleFragment", testSimpleFragment),
    ]
}

extension TempoInterpolationTests {
    static let __allTests = [
        ("testSecondsOffsetLinear_120to120", testSecondsOffsetLinear_120to120),
        ("testSecondsOffsetLinear_120to60_wholeNoteDuration", testSecondsOffsetLinear_120to60_wholeNoteDuration),
        ("testSecondsOffsetLinear_60to120_dottedHalfDuration", testSecondsOffsetLinear_60to120_dottedHalfDuration),
        ("testSecondsOffsetLinear_60to120_wholeNoteDuration", testSecondsOffsetLinear_60to120_wholeNoteDuration),
        ("testSecondsOffsetLinear_60to60", testSecondsOffsetLinear_60to60),
        ("testSecondsOffsetPowerIn2_120to60", testSecondsOffsetPowerIn2_120to60),
        ("testSecondsOffsetPowerIn2_120to60_tooSmallResolution", testSecondsOffsetPowerIn2_120to60_tooSmallResolution),
        ("testSecondsOffsetPowerIn2_60to120", testSecondsOffsetPowerIn2_60to120),
        ("testSecondsOffsetPowerIn2_60to60", testSecondsOffsetPowerIn2_60to60),
        ("testTempoLinear_120to60", testTempoLinear_120to60),
        ("testTempoLinear_60to120", testTempoLinear_60to120),
        ("testTempoPowerIn2_120to60", testTempoPowerIn2_120to60),
        ("testTempoPowerIn2_60to120", testTempoPowerIn2_60to120),
        ("testTempoPowerIn3_120to60", testTempoPowerIn3_120to60),
        ("testTempoPowerIn3_60to120", testTempoPowerIn3_60to120),
    ]
}

extension TempoTests {
    static let __allTests = [
        ("testInterpolationNoChange", testInterpolationNoChange),
        ("testTempoRespellingSubdivision", testTempoRespellingSubdivision),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EasingEvaluateTests.__allTests),
        testCase(EasingIntegrateTests.__allTests),
        testCase(StratumTests.__allTests),
        testCase(TempoInterpolationTests.__allTests),
        testCase(TempoTests.__allTests),
    ]
}
#endif
