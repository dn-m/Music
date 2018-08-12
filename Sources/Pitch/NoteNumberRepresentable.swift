//
//  NoteNumberRepresentable.swift
//  Pitch
//
//  Created by James Bean on 12/1/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import Math

// FIXME: Add default conformances for `Numeric`.

/// Protocol defining values representable by a `NoteNumber`.
public protocol NoteNumberRepresentable:
    Comparable,
    Hashable,
    ExpressibleByFloatLiteral,
    ExpressibleByIntegerLiteral
{
    
    // MARK: - Instance Properties
    
    /// The `NoteNumber` representation of the instance of `NoteNumberRepresentable` type.
    var noteNumber: NoteNumber { get }
    
    // MARK: - Initializers
    
    /// Create a `NoteNumberRepresentable` value with `NoteNumber`.
    init(noteNumber: NoteNumber)
}

extension NoteNumberRepresentable {
    
    // MARK: - `Hashable`
    
    /// Hash value of a `NoteNumberRepresentable` type.
    public var hashValue: Int {
        return noteNumber.hashValue
    }
}

extension NoteNumberRepresentable {
    
    // MARK: - `Equatable`
    
    /// - returns: `true` if both values are representable by the same `NoteNumber`.
    /// Otherwise, `false`.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.noteNumber == rhs.noteNumber
    }
}

extension NoteNumberRepresentable {
    
    // MARK: - `Comparable`
    
    /// - returns: `true` if the first value is less than the second value. Otherwise, `false`.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.noteNumber < rhs.noteNumber
    }
}

extension NoteNumberRepresentable {

    // MARK: - ExpressibleByFloatLiteral

    public init(floatLiteral value: Double) {
        self.init(noteNumber: NoteNumber(value))
    }
}

extension NoteNumberRepresentable {

    // MARK: - ExpressibleByIntegerLiteral

    public init(integerLiteral value: Int) {
        self.init(noteNumber: NoteNumber(Double(value)))
    }
}

// MARK: - Transposition

/// - Returns: A `NoteNumberRepresentable` value that is the sum of the two given
/// values.
public func + <T: NoteNumberRepresentable> (lhs: T, rhs: T) -> T {
    return T(noteNumber: NoteNumber(lhs.noteNumber.value + rhs.noteNumber.value))
}

/// - Returns: A `NoteNumberRepresentable` value that is the difference between the two given
/// values.
public func - <T: NoteNumberRepresentable> (lhs: T, rhs: T) -> T {
    return T(noteNumber: NoteNumber(lhs.noteNumber.value - rhs.noteNumber.value))
}

