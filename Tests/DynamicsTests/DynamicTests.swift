//
//  DynamicTests.swift
//  Dynamics
//
//  Created by James Bean on 4/27/16.
//
//

import XCTest
@testable import Dynamics

class DynamicTests: XCTestCase {

    func testAPI() {
        let forte = Dynamic.f
        XCTAssertEqual("\(forte)", "f")
        let piano = Dynamic.p
        XCTAssertEqual("\(piano)", "p")
        let mezzoForte = Dynamic.mf
        XCTAssertEqual("\(mezzoForte)", "mf")
        let mezzoPiano = Dynamic.mp
        XCTAssertEqual("\(mezzoPiano)", "mp")
        let triplePiano = Dynamic.p(3)
        XCTAssertEqual("\(triplePiano)", "ppp")
        let septupleForte = Dynamic.f(7)
        XCTAssertEqual("\(septupleForte)", "fffffff")
        let fortePiano = Dynamic.fp
        XCTAssertEqual("\(fortePiano)", "fp")
        let sforzando = Dynamic.sfz
        XCTAssertEqual("\(sforzando)", "sfz")
        let sfffffffz = Dynamic.s(.f(7)).z
        XCTAssertEqual("\(sfffffffz)", "sfffffffz")
        let rf = Dynamic.rf
        XCTAssertEqual("\(rf)", "rf")
        let rfz = Dynamic.rfz
        XCTAssertEqual("\(rfz)", "rfz")
        let rffff = Dynamic.r(.f(4))
        XCTAssertEqual("\(rffff)", "rffff")
        let sfp = Dynamic.s(.f,.p)
        XCTAssertEqual("\(sfp)", "sfp")
        let _: [Dynamic] = [.p, .f(4), .fff, .p(3), .mf, .s(.f,.p), .p(11), .r(.f(4))]
        //                   p   ffff   fff   ppp    mf   sfp        p       rfff
    }

    func testNumericValues() {
        XCTAssertEqual(Dynamic.f.numericValues.anterior, 1)
        XCTAssertEqual(Dynamic.f.numericValues.posterior, 1)
        XCTAssertEqual(Dynamic.p.numericValues.anterior, -1)
        XCTAssertEqual(Dynamic.p.numericValues.posterior, -1)
        XCTAssertEqual(Dynamic.mp.numericValues.anterior, -0.5)
        XCTAssertEqual(Dynamic.mp.numericValues.posterior, -0.5)
        XCTAssertEqual(Dynamic.mf.numericValues.anterior, 0.5)
        XCTAssertEqual(Dynamic.mf.numericValues.posterior, 0.5)
        XCTAssertEqual(Dynamic.fff.numericValues.anterior, 3)
        XCTAssertEqual(Dynamic.fff.numericValues.posterior, 3)
        XCTAssertEqual(Dynamic.ppp.numericValues.anterior, -3)
        XCTAssertEqual(Dynamic.ppp.numericValues.posterior, -3)
        XCTAssertEqual(Dynamic.fp.numericValues.anterior, 1)
        XCTAssertEqual(Dynamic.fp.numericValues.posterior, -1)
        XCTAssertEqual(Dynamic.sfffp.numericValues.anterior, 3)
        XCTAssertEqual(Dynamic.sfffp.numericValues.posterior, -1)
        XCTAssertEqual(Dynamic.sfppp.numericValues.anterior, 1)
        XCTAssertEqual(Dynamic.sfppp.numericValues.posterior, -3)
        XCTAssertGreaterThan(Dynamic.f.numericValues.posterior, Dynamic.p.numericValues.anterior)
    }
}
