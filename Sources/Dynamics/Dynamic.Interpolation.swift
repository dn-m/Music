//
//  Dynamic.Interpolation.swift
//  Dynamics
//
//  Created by James Bean on 4/27/16.
//
//

extension Dynamic {

    /// Interpolation between two `Dynamic` markings.
    public struct Interpolation: Equatable {

        /// The direction of a `Dynamic.Interpolation`.
        public enum Direction {

            // MARK: - Cases

            /// Crescendo
            case crescendo

            /// Decrescendo
            case decrescendo

            /// Static
            case none
        }

        // MARK: - Instance Properties

        /// The direction of a `Dynamic.Interpolation`.
        public let direction: Direction

        // MARK: - Initializers

        /// Create a `Dynamic.Interpolation` with the given `direction`.
        public init(direction: Direction) {
            self.direction = direction
        }

        /// Create a `Dynamic.Interpolation` between the given `Dynamic` values.
        public init(from source: Dynamic, to destination: Dynamic) {
            let source = source.numericValues.posterior
            let destination = destination.numericValues.anterior
            if source < destination {
                self.init(direction: .crescendo)
            } else if source > destination {
                self.init(direction: .decrescendo)
            } else {
                self.init(direction: .none)
            }
        }
    }
}
