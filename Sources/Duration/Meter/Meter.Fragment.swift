//
//  Meter.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Math

extension Meter {

    /// A fragment of a `Meter`. Wrapping a `base` meter along with the `range` of the fragment.
    public struct Fragment: DurationSpanningFragment {

        // MARK: - Instance Properties

        /// The meter of which this is a fragment.
        public let base: Meter

        /// The range of the fragment in the base meter.
        public let range: Range<Fraction>

        // MARK: - Initializers

        /// Create a `Meter.Fragment` of the given `meter` in the given `range`.
        // FIXME: Add range sanitation.
        public init(_ meter: Meter, in range: Range<Fraction>? = nil) {
            self.base = meter
            self.range = range ?? .zero ..< Fraction(meter)
        }

        /// Create a `Meter.Fragment` which encompasses the totality of the given `Meter`.
        public init(_ meter: Meter) {
            self.base = meter
            self.range = .zero ..< Fraction(meter)
        }

        // MARK: - Subscripts

        /// - Returns: `Interpolation.Fragment` in the given `range`.
        public subscript (range: Range<Fraction>) -> Meter.Fragment {
            assert(range.lowerBound >= self.range.lowerBound)
            assert(range.upperBound <= self.range.upperBound)
            return Meter.Fragment(base, in: range)
        }
    }
}

extension Meter.Fragment: Equatable { }
