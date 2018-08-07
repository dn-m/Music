//
//  Meter.Context.swift
//  Rhythm
//
//  Created by James Bean on 5/28/17.
//
//

import Math

extension Meter {

    public struct Context: Equatable {

        public let meter: Meter.Fragment
        public let offset: Fraction

        public init(meter: Meter.Fragment, at offset: Fraction) {
            self.meter = meter
            self.offset = offset
        }
    }
}
