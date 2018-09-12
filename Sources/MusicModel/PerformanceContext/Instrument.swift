//
//  Instrument.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import DataStructures

public struct Instrument {
    public let name: String
    public init(name: String) {
        self.name = name
    }
}

extension Instrument: Identifiable { }
extension Instrument: Equatable { }
extension Instrument: Hashable { }
