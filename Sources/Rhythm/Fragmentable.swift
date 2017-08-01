//
//  Fragmentable.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Algebra

/// Interface for types which can be fragmented into smaller pieces.
public protocol Fragmentable {

    // MARK: - Associated Types

    /// Type of fragment that is created.
    associatedtype Fragment

    /// Type of metric by which the domain of the fragment may be calculated.
    associatedtype Metric: SignedNumeric, Comparable, Additive

    // MARK: - Subscripts

    /// - Returns: `Fragment` within the given `range`.
    subscript(range: Range<Metric>) -> Fragment { get }
}

