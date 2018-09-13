//
//  Instrument.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import DataStructures

/// Model of a single music-making object, through which a `Performer` can actuate musical actions.
///
/// - TODO: Add `Instrument.Kind` metadata
/// - TODO: Add long name
/// - TODO: Add short name
/// - TODO: Add abbreviation (with default abbreviating method)
public struct Instrument {

    // MARK: - Instance Properties

    public let name: String

    // MARK: - Initializers

    public init(name: String) {
        self.name = name
    }
}

extension Instrument: Identifiable { }
extension Instrument: Equatable { }
extension Instrument: Hashable { }
