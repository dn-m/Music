import XCTest

extension DurationTests {
    static let __allTests = [
        ("testComparableReduced", testComparableReduced),
        ("testInitOperator", testInitOperator),
        ("testRange", testRange),
    ]
}

extension DurationTreeTests {
    static let __allTests = [
        ("testInitDuration", testInitDuration),
        ("testInitDurationProportionTreeOperator", testInitDurationProportionTreeOperator),
        ("testInitEmptyArray", testInitEmptyArray),
        ("testInitSubdivisionAndProportionTree", testInitSubdivisionAndProportionTree),
        ("testInitSubdivisionOperator", testInitSubdivisionOperator),
        ("testInitWithRelativeDurations", testInitWithRelativeDurations),
        ("testInitWithRelativeDurations13Over12", testInitWithRelativeDurations13Over12),
        ("testInitWithRelativeDurations4Over5", testInitWithRelativeDurations4Over5),
        ("testInitWithRelativeDurations5Over4", testInitWithRelativeDurations5Over4),
        ("testLeafOffsets", testLeafOffsets),
        ("testManyDurationTrees", testManyDurationTrees),
        ("testMultipleLeaves", testMultipleLeaves),
        ("testSingleLeaf", testSingleLeaf),
    ]
}

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

extension MeterCollectionTests {
    static let __allTests = [
        ("testFragmentOutOfRange", testFragmentOutOfRange),
        ("testFragmentRangeWithinSingleMeter", testFragmentRangeWithinSingleMeter),
        ("testFragmentUpperBoundBeyondEnd", testFragmentUpperBoundBeyondEnd),
        ("testFuzzManyFragments", testFuzzManyFragments),
        ("testTruncatingFragment", testTruncatingFragment),
    ]
}

extension MeterTests {
    static let __allTests = [
        ("testAdditiveMeter", testAdditiveMeter),
        ("testBeatOffsets", testBeatOffsets),
        ("testBeatOffsetsAdditive", testBeatOffsetsAdditive),
        ("testBeatOffsetsFractional", testBeatOffsetsFractional),
        ("testFractionalMeter", testFractionalMeter),
        ("testIrrationalMeter", testIrrationalMeter),
        ("testNormalMeter", testNormalMeter),
    ]
}

extension ProportionTreeTests {
    static let __allTests = [
        ("testInit", testInit),
        ("testmatchingParentsToChildrenSingleDepthDownThree", testmatchingParentsToChildrenSingleDepthDownThree),
        ("testmatchingParentsToChildrenSingleDepthDownTwo", testmatchingParentsToChildrenSingleDepthDownTwo),
        ("testmatchingParentsToChildrenSingleDepthUp", testmatchingParentsToChildrenSingleDepthUp),
        ("testMatchParentsVeryNestedMultipleCases", testMatchParentsVeryNestedMultipleCases),
        ("testNormalizedNested", testNormalizedNested),
        ("testNormalizeSingleDepth", testNormalizeSingleDepth),
        ("testNormalizeSingleDepthBranchOfSingleLeafOf3", testNormalizeSingleDepthBranchOfSingleLeafOf3),
        ("testNormalizeVeryNested", testNormalizeVeryNested),
        ("testReducedNested", testReducedNested),
        ("testReducedSingleDepth", testReducedSingleDepth),
        ("testReducedVeryNested", testReducedVeryNested),
        ("testScaleSimple", testScaleSimple),
    ]
}

extension RhythmTests {
    static let __allTests = [
        ("testDuratedEvents", testDuratedEvents),
        ("testInitWithDurationAndContextsUsage", testInitWithDurationAndContextsUsage),
        ("testInitWithDurationAndContextTupleUsage", testInitWithDurationAndContextTupleUsage),
        ("testInitWithDurationAndValueTupleUsage", testInitWithDurationAndValueTupleUsage),
        ("testLengths", testLengths),
        ("testLengthsAllTies", testLengthsAllTies),
        ("testLengthsSingleAllTies", testLengthsSingleAllTies),
        ("testLengthsSingleTiesAndEvents", testLengthsSingleTiesAndEvents),
        ("testLengthsSingleTiesEventsAndRests", testLengthsSingleTiesEventsAndRests),
        ("testLengthsTiesAndEvents", testLengthsTiesAndEvents),
        ("testLengthsTiesEventsAndRests", testLengthsTiesEventsAndRests),
        ("testMapEvents", testMapEvents),
        ("testReplaceEvents", testReplaceEvents),
    ]
}

extension RhythmTreeTests {
    static let __allTests = [
        ("testInit", testInit),
    ]
}

extension TempoInterpolationCollectionTests {
    static let __allTests = [
        ("testBuilderSingleInterpolation", testBuilderSingleInterpolation),
        ("testBuilderSingleStatic", testBuilderSingleStatic),
        ("testFirstOffset", testFirstOffset),
        ("testFragment", testFragment),
        ("testMoreComplexFragment", testMoreComplexFragment),
        ("testSimpleFragment", testSimpleFragment),
    ]
}

extension TempoInterpolationFragmentTests {
    static let __allTests = [
        ("testSecondsOffsetStatic120BPMFirstBeats", testSecondsOffsetStatic120BPMFirstBeats),
        ("testSecondsOffsetStatic120BPMLastBeats", testSecondsOffsetStatic120BPMLastBeats),
        ("testSecondsOffsetStatic120BPMMiddleBeats", testSecondsOffsetStatic120BPMMiddleBeats),
    ]
}

extension TempoInterpolationTests {
    static let __allTests = [
        ("testDurationStatic120BPM", testDurationStatic120BPM),
        ("testDurationStatic30BPM", testDurationStatic30BPM),
        ("testDurationStatic60BPM", testDurationStatic60BPM),
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
        ("testInitFloatLiteral", testInitFloatLiteral),
        ("testInitIntegerLiteral", testInitIntegerLiteral),
        ("testInterpolationStatic60BPMSecondsOffsets", testInterpolationStatic60BPMSecondsOffsets),
        ("testTempoRespellingSubdivision", testTempoRespellingSubdivision),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DurationTests.__allTests),
        testCase(DurationTreeTests.__allTests),
        testCase(EasingEvaluateTests.__allTests),
        testCase(EasingIntegrateTests.__allTests),
        testCase(MeterCollectionTests.__allTests),
        testCase(MeterTests.__allTests),
        testCase(ProportionTreeTests.__allTests),
        testCase(RhythmTests.__allTests),
        testCase(RhythmTreeTests.__allTests),
        testCase(TempoInterpolationCollectionTests.__allTests),
        testCase(TempoInterpolationFragmentTests.__allTests),
        testCase(TempoInterpolationTests.__allTests),
        testCase(TempoTests.__allTests),
    ]
}
#endif
