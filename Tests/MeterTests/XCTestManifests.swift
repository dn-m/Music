import XCTest

extension MeterCollectionTests {
    static let __allTests = [
        ("testFragmentOutOfRange", testFragmentOutOfRange),
        ("testFragmentRangeWithinSingleMeter", testFragmentRangeWithinSingleMeter),
        ("testFragmentsFromTutschkuUnder", testFragmentsFromTutschkuUnder),
        ("testFragmentUpperBoundBeyondEnd", testFragmentUpperBoundBeyondEnd),
        ("testTruncatingFragment", testTruncatingFragment),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MeterCollectionTests.__allTests),
    ]
}
#endif
