import XCTest

extension DurationTests {
    static let __allTests = [
        ("testComparableReduced", testComparableReduced),
        ("testInitOperator", testInitOperator),
        ("testRange", testRange),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DurationTests.__allTests),
    ]
}
#endif
