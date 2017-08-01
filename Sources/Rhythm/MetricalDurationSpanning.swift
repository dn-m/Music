//
//  MetricalDurationSpanning.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Math

// FIXME: Use constrained associated type in Swift 4:
// https://github.com/apple/swift-evolution/blob/master/proposals/0142-associated-types-constraints.md
public protocol MetricalDurationSpanning: Spanning where Metric == Fraction { }
