import XCTest

extension DynamicInterpolationTests {
    static let __allTests = [
        ("testInitCrescendo", testInitCrescendo),
        ("testInitDescrescendo", testInitDescrescendo),
        ("testInitStatic", testInitStatic),
    ]
}

extension DynamicTests {
    static let __allTests = [
        ("testAPI", testAPI),
        ("testNumericValues", testNumericValues),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DynamicInterpolationTests.__allTests),
        testCase(DynamicTests.__allTests),
    ]
}
#endif
