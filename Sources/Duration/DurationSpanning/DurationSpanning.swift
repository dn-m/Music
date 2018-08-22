//
//  DurationSpanning.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Math

/// Interface for types which span over a `Fraction`.
public protocol DurationSpanning: Intervallic where Metric == Fraction { }
