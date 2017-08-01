//
//  PitchConvertible.swift
//  Pitch
//
//  Created by James Bean on 6/3/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Math

/// Protocol defining types that can be initialized with a `Pitch` value.
public protocol PitchConvertible {
    
    // MARK: - Initializers

    /// Initialize with a `Pitch` value.
    init(_: Pitch)
}
