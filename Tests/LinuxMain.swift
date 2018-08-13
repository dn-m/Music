import XCTest

import ArticulationsTests
import TempoTests
import PitchTests
import MeterTests
import MusicModelTests
import MetricalDurationTests
import RhythmTests

var tests = [XCTestCaseEntry]()
tests += ArticulationsTests.__allTests()
tests += TempoTests.__allTests()
tests += PitchTests.__allTests()
tests += MeterTests.__allTests()
tests += MusicModelTests.__allTests()
tests += MetricalDurationTests.__allTests()
tests += RhythmTests.__allTests()

XCTMain(tests)
