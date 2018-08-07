//
//  MetricalDurationSpanningContainer.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

/// Interface for types which contain contiguous spans of `Fraction`-spanning elements.
public protocol MetricalDurationSpanningContainer: SpanningContainer
    where Spanner: MetricalDurationSpanningFragment { }
