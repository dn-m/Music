import XCTest

extension DynamicTests {
    static let __allTests = [
        ("testAPI", testAPI),
        ("testNumericValues", testNumericValues),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DynamicTests.__allTests),
    ]
}
#endif
