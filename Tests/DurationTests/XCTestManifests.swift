import XCTest

extension MetricalDurationTests {
    static let __allTests = [
        ("testComparableReduced", testComparableReduced),
        ("testInitOperator", testInitOperator),
        ("testRange", testRange),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MetricalDurationTests.__allTests),
    ]
}
#endif
