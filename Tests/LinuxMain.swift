import XCTest

import MusicModelTests
import ArticulationsTests
import DurationTests
import DynamicsTests
import PitchTests

var tests = [XCTestCaseEntry]()
tests += MusicModelTests.__allTests()
tests += ArticulationsTests.__allTests()
tests += DurationTests.__allTests()
tests += DynamicsTests.__allTests()
tests += PitchTests.__allTests()

XCTMain(tests)
