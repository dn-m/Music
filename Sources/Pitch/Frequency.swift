//
//  Frequency.swift
//  Pitch
//
//  Created by James Bean on 3/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import DataStructures

/// Periodic vibration in Hertz.
public struct Frequency: DoubleWrapping {

    // MARK: - Instance Properties
    
    /// Value of this `Frequency` in Hertz.
    public var value: Double
    
    // MARK: - Initializers
    
    /**
     Create a `Frequency` with a `NoteNumber` value.
     
     **Example:**
     
     ```
     let freq = Frequency(57.0) // => A below middle c
     ```
     */
    public init(_ noteNumber: NoteNumber) {
        self.value = 440.0 * pow(2.0, (noteNumber.value - 69.0) / 12.0)
    }
}

extension Frequency: ExpressibleByIntegerLiteral {
    
    // MARK: - `ExpressibleByIntegerLiteral`
    
    /**
     Create a `Frequency` with an `IntegerLiteralType`.
     
     **Example:**
     
     ```
     let freq: Frequency = 440 // => A below middle c
     ```
     */
    public init(integerLiteral value: Int) {
        self.value = Double(value)
    }
}

extension Frequency: ExpressibleByFloatLiteral {
    
    // MARK: - `FloatLiteralConvertible`
    
    /**
     Create a `Frequency` with a `FloatLiteralType`.
     
     **Example**:
     
     ```
     let freq: Frequency = 440.0 // => A below middle c
     ```
     */
    public init(floatLiteral value: Double) {
        self.value = value
    }
}
