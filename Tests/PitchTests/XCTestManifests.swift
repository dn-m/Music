import XCTest

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

extension NoteNumberTests {
    static let __allTests = [
        ("testNoteNumberInit", testNoteNumberInit),
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
        ("testPitchMinusFloat", testPitchMinusFloat),
        ("testPitchPlusFloat", testPitchPlusFloat),
    ]
}

extension ScaleTests {
    static let __allTests = [
        ("testInitAPI", testInitAPI),
        ("testMajor", testMajor),
        ("testMelodicMinor", testMelodicMinor),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ChordTests.__allTests),
        testCase(FrequencyTests.__allTests),
        testCase(NoteNumberTests.__allTests),
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
