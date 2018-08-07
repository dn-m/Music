//
//  Meter.Context.swift
//  Rhythm
//
//  Created by James Bean on 5/28/17.
//
//

import Math

extension Meter {

    /// The context of a `Meter.Fragment` in a container.
    public struct Context: Equatable {

        // MARK: - Instance Properties

        /// The meter fragment.
        public let meter: Meter.Fragment

        /// The offset of the meter fragment.
        public let offset: Fraction

        // MARK: - Instance Properties

        /// Create `Meter.Context` with the given `meter` at the given `offset`.
        public init(meter: Meter.Fragment, at offset: Fraction) {
            self.meter = meter
            self.offset = offset
        }
    }
}
