//
//  Spanning.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Algebra

/// Interface for types which have a length of some `Metric`.
///
/// - TODO: Move to dn-m/Collections
///
public protocol Spanning {

    // MARK: - Associated Types

    /// Type of the `length` of the `Spanning` type.
    associatedtype Metric: SignedNumeric, Comparable, Additive, Hashable

    // MARK: - Instance Properties

    /// Length of the `Spanning` type in the given `Metric`.
    var length: Metric { get }
}
