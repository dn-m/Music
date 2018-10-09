import XCTest

import ArticulationsTests
import PitchTests
import DurationTests
import DynamicsTests
import MusicModelTests

var tests = [XCTestCaseEntry]()
tests += ArticulationsTests.__allTests()
tests += PitchTests.__allTests()
tests += DurationTests.__allTests()
tests += DynamicsTests.__allTests()
tests += MusicModelTests.__allTests()

XCTMain(tests)
