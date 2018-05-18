//
//  Meter.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Math
import MetricalDuration

extension Meter {

    public struct Fragment: MetricalDurationSpanningFragment, Equatable {

        public typealias Metric = Fraction
        public typealias Fragment = Meter.Fragment

        public let base: Meter
        public let range: Range<Fraction>

        // FIXME: Add range sanitation.
        public init(_ meter: Meter, in range: Range<Fraction>? = nil) {
            self.base = meter
            self.range = range ?? .zero ..< Fraction(meter)
        }

        /// - Returns: `Interpolation.Fragment` in the given `range`.
        public subscript (range: Range<Fraction>) -> Meter.Fragment {
            assert(range.lowerBound >= self.range.lowerBound)
            assert(range.upperBound <= self.range.upperBound)
            return Meter.Fragment(base, in: range)
        }
    }
}

extension Meter.Fragment {

    public init(_ meter: Meter) {
        self.base = meter
        self.range = .zero ..< Fraction(meter)
    }
}
