//
//  NoteNumberRepresentable.swift
//  Pitch
//
//  Created by James Bean on 12/1/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import DataStructures
import Math

/// Protocol defining values representable by a `NoteNumber`.
public protocol NoteNumberRepresentable:
    NewType,
    Comparable,
    SignedNumeric,
    ExpressibleByFloatLiteral
{

    // MARK: - Instance Properties

    /// The `NoteNumber` representation of the instance of `NoteNumberRepresentable` type.
    var value: NoteNumber { get }

    // MARK: - Initializers

    /// Create a `NoteNumberRepresentable` value with `NoteNumber`.
    init(_ noteNumber: NoteNumber)
}

extension NoteNumberRepresentable {

    // MARK: - NewType

    public init(value: NoteNumber) {
        self.init(value)
    }
}

extension NoteNumberRepresentable {

    // MARK: - `Hashable`

    /// Hash value of a `NoteNumberRepresentable` type.
    public var hashValue: Int {
        return value.hashValue
    }
}

extension NoteNumberRepresentable {

    // MARK: - `Equatable`

    /// - returns: `true` if both values are representable by the same `NoteNumber`.
    /// Otherwise, `false`.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}

extension NoteNumberRepresentable {

    // MARK: - `Comparable`

    /// - returns: `true` if the first value is less than the second value. Otherwise, `false`.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
}

extension NoteNumberRepresentable {

    // MARK: - ExpressibleByFloatLiteral

    public init(floatLiteral value: Double) {
        self.init(NoteNumber(value))
    }
}

extension NoteNumberRepresentable {

    // MARK: - ExpressibleByIntegerLiteral

    public init(integerLiteral value: Int) {
        self.init(NoteNumber(Double(value)))
    }
}

extension NoteNumberRepresentable {

    public var magnitude: NoteNumber.Magnitude {
        return value.magnitude
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value + rhs.value)
    }

    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value - rhs.value)
    }

    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    public static func * (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value * rhs.value)
    }

    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    public init?<T>(exactly source: T) where T: BinaryInteger {
        guard let value = NoteNumber(exactly: source) else { return nil }
        self.init(value)
    }
}
