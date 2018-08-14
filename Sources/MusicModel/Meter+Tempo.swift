//
//  Meter+Tempo.swift
//  MusicModel
//
//  Created by James Bean on 8/27/17.
//
//

import Duration

extension Meter {

    /// - returns: Offsets of each beat of a `Meter` at the given `Tempo`.
    ///
    /// - TODO: Change [Double] -> [Seconds]
    ///
    public func offsets(tempo: Tempo) -> [Double] {
        let durationForBeat = tempo.duration(forBeatAt: denominator)
        return (0..<numerator).map { Double($0) * durationForBeat }
    }

    /// - returns: Duration in seconds of measure at the given `tempo`.
    public func duration(at tempo: Tempo) -> Double {
        return Double(numerator) * tempo.duration(forBeatAt: denominator)
    }

}
