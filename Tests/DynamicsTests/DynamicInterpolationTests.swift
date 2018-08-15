//
//  DynamicInterpolationTests.swift
//  Dynamics
//
//  Created by James Bean on 5/1/16.
//
//

import XCTest
@testable import Dynamics


class DynamicInterpolationTests: XCTestCase {

    func testInitStatic() {
        let interp = Dynamic.Interpolation(from: .sfff, to: .fff)
        let expected = Dynamic.Interpolation(direction: .none)
        XCTAssertEqual(interp, expected)
    }

    func testInitCrescendo() {
        let interp = Dynamic.Interpolation(from: .fppp, to: .rffz)
        let expected = Dynamic.Interpolation(direction: .crescendo)
        XCTAssertEqual(interp, expected)
    }
}
