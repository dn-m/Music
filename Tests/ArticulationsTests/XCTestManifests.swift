import XCTest

extension ArticulationTests {
    static let __allTests = [
        ("testArticulations", testArticulations),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArticulationTests.__allTests),
    ]
}
#endif
