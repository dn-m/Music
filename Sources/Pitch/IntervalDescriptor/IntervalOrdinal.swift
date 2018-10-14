//
//  IntervalOrdinal.swift
//  Pitch
//
//  Created by James Bean on 10/10/18.
//

import Math

/// Interface for `IntervalOrdinal`-like values.
public protocol IntervalOrdinal {

    // MARK: - Initializers

    /// Creates a `IntervalOrdinal` with the given amount of `steps`.
    init?(steps: Int)
}
