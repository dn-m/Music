//
//  Tempo.Context.swift
//  Rhythm
//
//  Created by James Bean on 5/27/17.
//
//

import Math

extension Tempo {

    /// The context of a particular point within a `Tempo.Interpolation`.
    public struct Context: Equatable {

        // MARK: - Instance Properties

        /// Effective tempo at current offset within interpolation.
        let tempo: Tempo

        /// Interpolation containing context.
        let interpolation: Interpolation

        // MARK: - Initializers

        /// Creates a `Tempo.Context` with a given `interpolation` and `metricalOffset`.
        public init(interpolation: Interpolation, metricalOffset: Fraction) {
            self.interpolation = interpolation
            self.tempo = interpolation.tempo(at: metricalOffset)
        }
    }
}
