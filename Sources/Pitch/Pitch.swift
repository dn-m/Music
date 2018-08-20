//
//  Pitch.swift
//  Pitch
//
//  Created by James Bean on 3/12/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Math

/// The quality of a sound governed by the rate of vibrations producing it.
public struct Pitch: NoteNumberRepresentable {


    /// Modulo-12 representation of `NoteNumber` representation of `Pitch`.
    public var `class`: Pitch.Class {
        return Pitch.Class(self)
    }
    
    // MARK: - Instance Properties
    
    /// `NoteNumber` representation of `Pitch`.
    public let noteNumber: NoteNumber
    
    /// `Frequency` representation of `Pitch`.
    public let frequency: Frequency
    
    // MARK: - Initializers
    
    /**
     Create a `Pitch` with a `NoteNumber` value.
     
     **Example:**
     ```
     let p = Pitch(noteNumber: 60) // => middle C
     ```
     */
    public init(noteNumber: NoteNumber) {
        self.noteNumber = noteNumber
        self.frequency = Frequency(noteNumber)
    }
    
    /**
     Create a `Pitch` with a `Frequency` value.
     
     **Example:**
     ```
     let p = Pitch(frequency: 440) // => A below middle C
     ```
     */
    public init(frequency: Frequency) {
        self.frequency = frequency
        self.noteNumber = NoteNumber(frequency)
    }
}

extension Pitch: PitchConvertible {
    
    // MARK: - `PitchConvertible`
    
    /// Create a `Pitch` with another `Pitch`.
    public init(_ pitch: Pitch) {
        self.frequency = pitch.frequency
        self.noteNumber = NoteNumber(pitch.frequency)
    }
}

extension Pitch: ExpressibleByFloatLiteral {
    
    // MARK: - `ExpressibleByFloatLiteral`
    
    /// Create a `Pitch` with a `FloatLiteral`. This value is the `NoteNumber` value.
    public init(floatLiteral value: Double) {
        self.init(noteNumber: NoteNumber(value))
    }
}

extension Pitch: ExpressibleByIntegerLiteral {
    
    // MARK: - `ExpressibleByIntegerLiteral`
    
    /// Create a `Pitch` with an `IntegerLiteral`. This value is the `NoteNumber` value.
    public init(integerLiteral value: Int) {
        self.init(noteNumber: NoteNumber(Double(value)))
    }
}

extension Pitch: Hashable {
    
    // MARK: - `Hashable`

    /// Hash value.
    public var hashValue: Int {
        return noteNumber.hashValue
    }
}

extension Pitch: CustomStringConvertible {
 
    // MARK: - `CustomStringConvertible`
    
    /// Printed description.
    public var description: String {
        return "\(noteNumber.value)"
    }
}

// MARK: - Transposition

func + (lhs: Pitch, rhs: Double) -> Pitch {
    return Pitch(noteNumber: NoteNumber(lhs.noteNumber.value + rhs))
}

func + (lhs: Double, rhs: Pitch) -> Pitch {
    return Pitch(noteNumber: NoteNumber(lhs + rhs.noteNumber.value))
}

func - (lhs: Pitch, rhs: Double) -> Pitch {
    return Pitch(noteNumber: NoteNumber(lhs.noteNumber.value - rhs))
}

func - (lhs: Double, rhs: Pitch) -> Pitch {
    return Pitch(noteNumber: NoteNumber(lhs - rhs.noteNumber.value))
}

