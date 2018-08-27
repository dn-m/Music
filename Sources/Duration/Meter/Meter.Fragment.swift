//
//  Meter.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import DataStructures
import Math

extension Meter {

    /// A fragment of a `Meter`. Wrapping a `base` meter along with the `range` of the fragment.
    public struct Fragment {

        // MARK: - Instance Properties

        /// The meter of which this is a fragment.
        public let base: Meter

        /// The range of the fragment in the base meter.
        public let range: Range<Fraction>
    }
}

extension Meter.Fragment {

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
}

extension Meter.Fragment: Intervallic {

    // MARK: - Intervallic

    /// A `Meter.Fragment` is measured by a `Fraction` value.
    public typealias Metric = Fraction

    /// - Returns: The fractional length of this `Meter.Fraction`.
    public var length: Fraction {
        return range.length
    }
}

extension Meter.Fragment: Totalizable {

    // MARK: - Totalizable

    /// Creates a `Meter.Fragment` with the given `whole` `Meter`.
    public init(whole: Meter) {
        self.init(whole)
    }
}

extension Meter.Fragment: IntervallicFragmentable {

    // MARK: - IntervallicFragmentable

    /// The fragment type of a `Meter.Fragment` is a `Meter.Fragment`.
    public typealias Fragment = Meter.Fragment

    /// - Returns: A `Meter.Fragment` in the given `range`.
    public func fragment(in range: Range<Fraction>) -> Fragment {
        return Fragment(base, in: range)
    }
}

extension Meter.Fragment: Equatable { }
extension Meter.Fragment: Hashable { }
