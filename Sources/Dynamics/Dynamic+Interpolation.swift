//
//  Dynamic+Interpolation.swift
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
        init(direction: Direction) {
            self.direction = direction
        }
    }
}
