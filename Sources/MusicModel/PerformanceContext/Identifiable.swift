//
//  Identifiable.swift
//  MusicModel
//
//  Created by James Bean on 9/12/18.
//

import DataStructures

/// Protocol which creates a type-safe identifier for the conforming type.
public protocol Identifiable {
    typealias ID = Identifier<Self>
}

