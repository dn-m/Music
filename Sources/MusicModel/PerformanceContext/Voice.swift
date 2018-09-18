//
//  Voice.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import DataStructures

/// Model of a single `Voice` in a `PerformanceContext`, actuated by a single performer through a
/// single instrument.
///
/// - TODO: Add long name
/// - TODO: Add short name
/// - TODO: Add abbreviation (with default abbreviating method)
/// - TODO: Add more metadata
public struct Voice {

    /// The name of this voice.
    let name: String

    // MARK: - Initializers

    public init(name: String) {
        self.name = name
    }
}

extension Voice: Identifiable { }
extension Voice: Equatable { }
extension Voice: Hashable { }
