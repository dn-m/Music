//
//  Meter.Context.swift
//  Rhythm
//
//  Created by James Bean on 5/28/17.
//
//

extension Meter {

    public struct Context {

        public let meter: Meter.Fragment
        public let offset: MetricalDuration

        public init(meter: Meter.Fragment, at offset: MetricalDuration) {
            self.meter = meter
            self.offset = offset
        }
    }
}
