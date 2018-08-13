//
//  BeatContext.swift
//  MusicModel
//
//  Created by James Bean on 8/26/17.
//

import Math
import Duration

// TODO: Move to `dn-m/MetronomeController`
/// Information about a given beat within a `Meter`.
public struct BeatContext: Equatable {

    // MARK: - Instance Properties

    /// - Returns: Metrical offset from start of a `Meter.Structure`.
    public var metricalOffset: Duration {
        let rangeOffsetFraction = meterContext.meter.range.lowerBound
        let rangeOffset = rangeOffsetFraction.numerator /> rangeOffsetFraction.denominator
        return Duration(meterContext.offset.numerator, meterContext.offset.denominator) + offset - rangeOffset
    }

    /// Meter containing `BeatContext`.
    public let meterContext: Meter.Context

    /// Metrical offset of beat within `Meter`.
    public let offset: Duration

    // MARK: - Initializers

    /// Creates a `BeatContext` with the given `subdivision` and `position`.
    public init(
        meterContext: Meter.Context,
        offset: Duration,
        interpolation: Tempo.Interpolation
    )
    {
        self.meterContext = meterContext
        self.offset = offset
    }
}
