//
//  Performer.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import struct Foundation.UUID
import DataStructures

/// Model of a single `Performer` in a `PerformanceContext`.
public struct Performer: Equatable, Hashable {
    
    // MARK: - Associated Types
    
    /// Type of `Identifier`.
    public typealias Identifier = String

    // MARK: - Instance Properties
    
    /// Identifier.
    public let identifier: Identifier
    
    /// Storage of `Instrument` values by their `identifier`.
    public let instruments: [Instrument.Identifier: Instrument]
    
    // MARK: - Inializers
    
    /// Create a `Performer` with a given `identifier` and an array of `Instrument` values.
    public init(
        _ identifier: Identifier = UUID().uuidString,
        _ instruments: [Instrument] = []
    )
    {
        self.identifier = identifier
        self.instruments = Dictionary(instruments.map { ($0.identifier, $0) })
    }
    
    // MARK: - Instance Methods
    
    /// - returns: `Instrument` with the given `id`, if present. Otherwise, `nil`.
    public func instrument(id: Instrument.Identifier) -> Instrument? {
        return instruments[id]
    }
}

extension Performer: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "Performer: \(identifier)\n" + (instruments.map { "- \($0)" }.joined(separator: "\n"))
    }
}

extension Performer: CollectionWrapping {
    
    // MARK: - CollectionWrapping
    
    public var base: [Instrument.Identifier: Instrument] {
        return instruments
    }
}
