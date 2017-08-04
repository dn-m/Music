//
//  Instrument.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import StructureWrapping

/// - TODO: Add instrument specifications (`vn`, `vc`, `tpt`, `bfl cl`, etc.)
/// - TODO: Add rich naming `(Name(long:, short:)`)
public struct Instrument {
    
    // MARK: - Associated Types
    
    public typealias Identifier = String

    // MARK: - Instance Properties
    
    /// Identifier.
    public let identifier: Identifier
    
    /// Storage of `Voice` values by their `identifier`.
    public let voices: [Voice.Identifier: Voice]
    
    // MARK: - Initializers
    
    /// Create an `Instrument` with an `identifier` and an array of `Voice` values.
    public init(_ identifier: Identifier, _ voices: [Voice] = [Voice(0)]) {
        self.identifier = identifier
        self.voices = Dictionary(voices.map { ($0.identifier, $0) })
    }
    
    // MARK: - Instance Methods
    
    /// - returns: The `Voice` with the given `id`, if present. Otherwise, `nil`.
    public func voice(id: Voice.Identifier) -> Voice? {
        return voices[id]
    }
}

extension Instrument: CustomStringConvertible {
    
    public var description: String {
        return "Instrument: \(identifier)\n" + voices.map { "- \($0)" }.joined(separator: "\n")
    }
}

extension Instrument: CollectionWrapping {
    
    public var base: [Voice.Identifier: Voice] {
        return voices
    }
}

extension Instrument: Equatable {
    
    public static func == (lhs: Instrument, rhs: Instrument) -> Bool {
        return lhs.voices == rhs.voices
    }
}

extension Instrument: Hashable {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
}
