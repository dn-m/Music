import XCTest

extension ChordDescriptorTests {
    static let __allTests = [
        ("testInitAPI", testInitAPI),
    ]
}

extension ChordTests {
    static let __allTests = [
        ("testCMajor", testCMajor),
        ("testFSharpMinor", testFSharpMinor),
        ("testInitAPI", testInitAPI),
        ("testIntervalPattern", testIntervalPattern),
    ]
}

extension FrequencyTests {
    static let __allTests = [
        ("testInitIntLiteral", testInitIntLiteral),
    ]
}

extension IntervalQualityTests {
    static let __allTests = [
        ("testInverseDimAug", testInverseDimAug),
        ("testInverseMinorMajor", testInverseMinorMajor),
        ("testInversePerfect", testInversePerfect),
    ]
}

extension NoteNumberTests {
    static let __allTests = [
        ("testNoteNumberInit", testNoteNumberInit),
    ]
}

extension OrderedIntervalDescriptorTests {
    static let __allTests = [
        ("testAbsoluteNamedIntervalOrdinalInversion", testAbsoluteNamedIntervalOrdinalInversion),
        ("testAPI", testAPI),
        ("testAPIShouldNotCompile", testAPIShouldNotCompile),
        ("testDoubleAugmentedThirdDoubleDiminishedSixth", testDoubleAugmentedThirdDoubleDiminishedSixth),
        ("testInversionMajorSecondMinorSeventh", testInversionMajorSecondMinorSeventh),
        ("testInversionMajorThirdMinorSixth", testInversionMajorThirdMinorSixth),
        ("testInversionPerfectFifthPerfectFourth", testInversionPerfectFifthPerfectFourth),
        ("testPerfectOrdinalFourthFifthInverse", testPerfectOrdinalFourthFifthInverse),
        ("testPerfectOrdinalUnisonInverse", testPerfectOrdinalUnisonInverse),
        ("testSecondOrdinalInverseSeventh", testSecondOrdinalInverseSeventh),
    ]
}

extension PitchClassDyadTests {
    static let __allTests = [
        ("testEquality", testEquality),
        ("testEqualityNotEqual", testEqualityNotEqual),
        ("testOrderedIntervalCrossOver", testOrderedIntervalCrossOver),
        ("testOrderedIntervalEasy", testOrderedIntervalEasy),
    ]
}

extension PitchClassIntervalTests {
    static let __allTests = [
        ("testInit", testInit),
    ]
}

extension PitchClassSetTests {
    static let __allTests = [
        ("testEquality", testEquality),
    ]
}

extension PitchClassTests {
    static let __allTests = [
        ("testAdd", testAdd),
        ("testPitchClass", testPitchClass),
        ("testPitchClassInitFloatGreaterThan12", testPitchClassInitFloatGreaterThan12),
        ("testPitchClassInitFloatLessThan12", testPitchClassInitFloatLessThan12),
        ("testPitchClassInitIntGreaterThan12", testPitchClassInitIntGreaterThan12),
        ("testPitchClassInitIntLessThan12", testPitchClassInitIntLessThan12),
        ("testPitchClassInitWithFloat", testPitchClassInitWithFloat),
        ("testSubtract", testSubtract),
    ]
}

extension PitchDyadTests {
    static let __allTests = [
        ("testEqualityFalseHigherNotEqual", testEqualityFalseHigherNotEqual),
        ("testEqualityFalseLowerNotEqual", testEqualityFalseLowerNotEqual),
        ("testEqualityFalseNeitherEqual", testEqualityFalseNeitherEqual),
        ("testEqualityTrue", testEqualityTrue),
        ("testInitOrdered", testInitOrdered),
        ("testInterval", testInterval),
    ]
}

extension PitchIntervalTests {
    static let __allTests = [
        ("testEquatable", testEquatable),
        ("testInit", testInit),
    ]
}

extension PitchSegmentTests {
    static let __allTests = [
        ("testNormalFormSinglePitch", testNormalFormSinglePitch),
        ("testNormalFormWrapping", testNormalFormWrapping),
        ("testPrimeForm", testPrimeForm),
        ("testPrimeFormsEqual", testPrimeFormsEqual),
    ]
}

extension PitchSetTests {
    static let __allTests = [
        ("testDyads", testDyads),
        ("testPitchClassSet", testPitchClassSet),
    ]
}

extension PitchTests {
    static let __allTests = [
        ("testFloatMinusPitch", testFloatMinusPitch),
        ("testFloatPlusPitch", testFloatPlusPitch),
        ("testInit", testInit),
        ("testPitchAdditiveMonoid", testPitchAdditiveMonoid),
        ("testPitchMinusFloat", testPitchMinusFloat),
        ("testPitchPlusFloat", testPitchPlusFloat),
    ]
}

extension ScaleTests {
    static let __allTests = [
        ("testInitAPI", testInitAPI),
        ("testMajor", testMajor),
        ("testMelodicMinor", testMelodicMinor),
        ("testPitchFromScaleDegree0", testPitchFromScaleDegree0),
        ("testPitchFromScaleDegree3", testPitchFromScaleDegree3),
        ("testPitchFromScaleDegree9", testPitchFromScaleDegree9),
        ("testPitchFromScaleDegreeNotNil", testPitchFromScaleDegreeNotNil),
        ("testScaleDegree", testScaleDegree),
        ("testScaleDegreeNil", testScaleDegreeNil),
        ("testScaleDegreeNotNil", testScaleDegreeNotNil),
        ("testScaleSequenceLooping", testScaleSequenceLooping),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ChordDescriptorTests.__allTests),
        testCase(ChordTests.__allTests),
        testCase(FrequencyTests.__allTests),
        testCase(IntervalQualityTests.__allTests),
        testCase(NoteNumberTests.__allTests),
        testCase(OrderedIntervalDescriptorTests.__allTests),
        testCase(PitchClassDyadTests.__allTests),
        testCase(PitchClassIntervalTests.__allTests),
        testCase(PitchClassSetTests.__allTests),
        testCase(PitchClassTests.__allTests),
        testCase(PitchDyadTests.__allTests),
        testCase(PitchIntervalTests.__allTests),
        testCase(PitchSegmentTests.__allTests),
        testCase(PitchSetTests.__allTests),
        testCase(PitchTests.__allTests),
        testCase(ScaleTests.__allTests),
    ]
}
#endif
