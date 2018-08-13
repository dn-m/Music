import XCTest

extension MetricalDurationTreeTests {
    static let __allTests = [
        ("testInitEmptyArray", testInitEmptyArray),
        ("testInitMetricalDuration", testInitMetricalDuration),
        ("testInitMetricalDurationProportionTreeOperator", testInitMetricalDurationProportionTreeOperator),
        ("testInitSubdivisionAndProportionTree", testInitSubdivisionAndProportionTree),
        ("testInitSubdivisionOperator", testInitSubdivisionOperator),
        ("testInitWithRelativeDurations", testInitWithRelativeDurations),
        ("testInitWithRelativeDurations13Over12", testInitWithRelativeDurations13Over12),
        ("testInitWithRelativeDurations4Over5", testInitWithRelativeDurations4Over5),
        ("testInitWithRelativeDurations5Over4", testInitWithRelativeDurations5Over4),
        ("testLeafOffsets", testLeafOffsets),
        ("testMultipleLeaves", testMultipleLeaves),
        ("testSingleLeaf", testSingleLeaf),
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
        ("testInitWithDurationAndContextsUsage", testInitWithDurationAndContextsUsage),
        ("testInitWithDurationAndContextTupleUsage", testInitWithDurationAndContextTupleUsage),
        ("testInitWithDurationAndValueTupleUsage", testInitWithDurationAndValueTupleUsage),
        ("testLengths", testLengths),
        ("testLengthsAllTies", testLengthsAllTies),
        ("testLengthsTiesAndEvents", testLengthsTiesAndEvents),
        ("testLengthsTiesEventsAndRests", testLengthsTiesEventsAndRests),
    ]
}

extension RhythmTreeTests {
    static let __allTests = [
        ("testInit", testInit),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MetricalDurationTreeTests.__allTests),
        testCase(ProportionTreeTests.__allTests),
        testCase(RhythmTests.__allTests),
        testCase(RhythmTreeTests.__allTests),
    ]
}
#endif
