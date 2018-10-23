//
//  ChordDescriptorTests.swift
//  PitchTests
//
//  Created by James Bean on 10/23/18.
//

import XCTest
import Pitch

class ChordDescriptorTests: XCTestCase {

    func testInitAPI() {
        let _: ChordDescriptor = [.M3, .m3]
        let _: ChordDescriptor = [.m3, .M3]
        let _: ChordDescriptor = [.m3, .m3]
        let _: ChordDescriptor = [.M3, .M3]
    }
}
