//
//  BeatContext.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Math

// TODO: Move to `dn-m/MetronomeController`
/// Information about a given beat within a `Meter`.
public struct BeatContext {

    // MARK: - Instance Properties

    /// - returns: Metrical offset from start of a `Meter.Structure`.
    public var metricalOffset: MetricalDuration {
        let rangeOffsetFraction = meterContext.meter.range.lowerBound
        let rangeOffset = rangeOffsetFraction.numerator /> rangeOffsetFraction.denominator
        return meterContext.offset + offset - rangeOffset
    }

    /// Meter containing `BeatContext`.
    public let meterContext: Meter.Context

    /// Metrical offset of beat within `Meter`.
    public let offset: MetricalDuration

    // MARK: - Initializers

    /// Creates a `BeatContext` with the given `subdivision` and `position`.
    public init(
        meterContext: Meter.Context,
        offset: MetricalDuration,
        interpolation: Tempo.Interpolation
    )
    {
        self.meterContext = meterContext
        self.offset = offset
    }
}
