import XCTest

import ArticulationsTests
import DurationTests
import DynamicsTests
import MusicModelTests
import PitchTests

var tests = [XCTestCaseEntry]()
tests += ArticulationsTests.__allTests()
tests += DurationTests.__allTests()
tests += DynamicsTests.__allTests()
tests += MusicModelTests.__allTests()
tests += PitchTests.__allTests()

XCTMain(tests)
