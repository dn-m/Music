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
    Hashable,
    Comparable,
    SignedNumeric,
    ExpressibleByFloatLiteral
{

    // MARK: - Instance Properties

    /// The `NoteNumber` representation of the instance of `NoteNumberRepresentable` type.
    var value: NoteNumber { get }

    // MARK: - Initializers

    /// Create a `NoteNumberRepresentable` value with given `NoteNumber`.
    init(_ noteNumber: NoteNumber)
}

extension NoteNumberRepresentable {

    // MARK: - Initializers

    /// Create a `NoteNumberRepresentable` value with given `NoteNumber`.
    public init(value: NoteNumber) {
        self.init(value)
    }

    /// Creates a `NoteNumberRepresentable`-conforming type value with the given `Double` value.
    public init(_ value: Double) {
        self.init(NoteNumber(value))
    }

    /// Creates a `NoteNumberRepresentable`-conforming type value with another.
    public init <N> (_ value: N) where N: NoteNumberRepresentable {
        self.init(value.value)
    }
}

extension NoteNumberRepresentable {

    // MARK: - Hashable

    /// - Returns: The hash value of a `NoteNumberRepresentable` type.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension NoteNumberRepresentable {

    // MARK: - Equatable

    /// - Returns: `true` if both values are representable by the same `NoteNumber`.
    /// Otherwise, `false`.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}

extension NoteNumberRepresentable {

    // MARK: - Comparable

    /// - Returns: `true` if the first value is less than the second value. Otherwise, `false`.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
}

extension NoteNumberRepresentable {

    // MARK: - ExpressibleByFloatLiteral

    /// Creates a `NoteNumberRepresentable`-conforming type with the given float literal.
    public init(floatLiteral value: Double) {
        self.init(NoteNumber(value))
    }
}

extension NoteNumberRepresentable {

    // MARK: - ExpressibleByIntegerLiteral

    /// Creates a `NoteNumberRepresentable`-conforming type with the given integer literal.
    public init(integerLiteral value: Int) {
        self.init(NoteNumber(Double(value)))
    }
}

extension NoteNumberRepresentable {

    // MARK: - SignedNumeric

    /// - Returns: The magnitude of this `NoteNumberRepresentable`-conforming type value.
    public var magnitude: NoteNumber.Magnitude {
        return value.magnitude
    }

    /// - Returns: The sum of the two given `NoteNumberRepresentable`-conforming type values.
    public static func + (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value + rhs.value)
    }

    /// - Returns: Adds the right-hand-side value to the left-hand-side value.
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    /// - Returns: The difference between the left-hand-side value and the right-hand-side value.
    public static func - (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value - rhs.value)
    }

    /// - Returns: Subtracts the right-hand-side value from the left-hand-side value.
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    /// - Returns: The product of the left-hand-side value and the right-hand-side value.
    public static func * (lhs: Self, rhs: Self) -> Self {
        return .init(lhs.value * rhs.value)
    }

    /// - Returns: Multiplies the right-hand-side value by the left-hand-side value.
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    /// Creates a `NoteNumberRepresentable`-conforming type value with the given `source` value.
    public init?<T>(exactly source: T) where T: BinaryInteger {
        guard let value = NoteNumber(exactly: source) else { return nil }
        self.init(value)
    }
}
