//
//  Performer.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import DataStructures

/// Model of a single music-making agent.
///
/// - TODO: Add long name
/// - TODO: Add short name
/// - TODO: Add abbreviation (with default abbreviating method)
/// - TODO: Add more metadata
public struct Performer {

    // MARK: - Instance Properties

    public let name: String

    // MARK: - Initializers

    /// Creates a `Performer` with the given `name`.
    public init(name: String) {
        self.name = name
    }
}

extension Performer: Identifiable { }
extension Performer: Equatable { }
extension Performer: Hashable { }
