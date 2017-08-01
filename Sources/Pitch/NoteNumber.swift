//
//  NoteNumber.swift
//  Pitch
//
//  Created by James Bean on 3/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Darwin
import StructureWrapping

/**
 MIDI NoteNumber.
 */
public struct NoteNumber: DoubleWrapping {
    
    // MARK: - Type Methods
    
    /**
     - returns: NoteNumber with a random value between 60 and 72, with the given `resolution`.
     
     - TODO: Implement `inRange: _` or similar.
     */
    public static func random(resolution: Double = 1) -> NoteNumber {
        return NoteNumber(Double.random(min: 60, max: 72))
    }
    
    // MARK: - Instance Properties
    
    /// Value of this `NoteNumber`.
    public var value: Double
    
    // MARK: - Initializers
    
    /**
     Create a `NoteNumber` with `Frequency` value.
     
     **Example:**
     
     ```
     let nn = NoteNumber(440) => A below middle c
     ```
     */
    public init(_ frequency: Frequency) {
        self.value = 69.0 + (12.0 * (log(frequency.value / 440.0) / log(2.0)))
    }
 
    /**
     - `1`: quantize to a half-tone
     - `0.5`: quantize to a quarter-tone
     - `0.25`: quantize to an eighth-tone
     
     - returns: `NoteNumber` that is quantized to the desired `resolution`.
     */
    public func quantized(to resolution: Double) -> NoteNumber {
        return NoteNumber(floatLiteral: round(value / resolution) * resolution)
    }
}

extension NoteNumber: ExpressibleByIntegerLiteral {
    
    // MARK: `ExpressibleByIntegerLiteral`
    
    /**
     Create a `NoteNumber` with an `IntegerLiteralType`.
     
     **Example:**
     
     ```
     let nn: NoteNumber = 65 => F above middle C
     ```
     */
    public init(integerLiteral value: Int) {
        self.value = Double(value)
    }
}

extension NoteNumber: ExpressibleByFloatLiteral {
    
    // MARK: `ExpressibleByDoubleLiteral`
    
    /**
     Create a `NoteNumber` with a `DoubleLiteralType`.
     
     **Example:**
     
     ```
     let nn: NoteNumber = 65.5 // => F quarter sharp above middle C
     ```
     */
    public init(floatLiteral value: Double) {
        self.value = value
    }
}

/// - returns: The difference between two `NoteNumber` values.
public func - (lhs: NoteNumber, rhs: NoteNumber) -> NoteNumber {
    return NoteNumber(lhs.value - rhs.value)
}
