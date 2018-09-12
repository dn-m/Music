//
//  Performer.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import DataStructures

public struct Performer {
    public let name: String
    public init(name: String) {
        self.name = name
    }
}

extension Performer: Identifiable { }
extension Performer: Equatable { }
extension Performer: Hashable { }
