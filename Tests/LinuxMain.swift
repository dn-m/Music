import XCTest

import ArticulationsTests
import DurationTests
import DynamicsTests
import PitchTests
import MusicModelTests

var tests = [XCTestCaseEntry]()
tests += ArticulationsTests.__allTests()
tests += DurationTests.__allTests()
tests += DynamicsTests.__allTests()
tests += PitchTests.__allTests()
tests += MusicModelTests.__allTests()

XCTMain(tests)
