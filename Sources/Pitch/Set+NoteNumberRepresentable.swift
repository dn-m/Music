//
//  Set+NoteNumberRepresentable.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

import Math

extension Collection where Element: NoteNumberRepresentable {

    // TODO: Make lazy
    // FIXME: Should not need to create `Array` (audit `pairs`)
    public var intervals: [OrderedInterval<Iterator.Element>] {
        return Array(self).pairs.map(OrderedInterval.init)
    }

    // TODO: Make lazy
    // FIXME: Should not need to create `Array` (audit `pairs`)
    public var dyads: [Dyad<Iterator.Element>] {
        return Array(self).subsets(cardinality: 2).map(Dyad.init)
    }
}

extension Collection where Element == Pitch.Class {

    /// Normal form of a Pitch.Class segment
    public var normalForm: [Pitch.Class] {
        return sorted().rotations |> mostCompact >>> mostLeftPacked
    }

    /// - Returns: The Prime Form
    public var primeForm: [Pitch.Class] {
        guard !isEmpty else { return map { $0 } }
        let normalForm = self.normalForm
        let inverse = normalForm.inversion.normalForm
        return mostLeftPacked([normalForm, inverse]).reduced
    }

    public var reduced: [Pitch.Class] {
        assert(count > 0)
        return map { $0 - first! }
    }

    public var inversion: [Pitch.Class] {
        return map { $0.inversion }
    }

    // FIXME: Lift rotated to Collection rather than Array
    private var rotations: [[Pitch.Class]] {
        let values = Array(self)
        return (0..<values.count).map { amount in values.rotated(by: amount) }
    }
}

func mostCompact(_ values: [[Pitch.Class]]) -> [[Pitch.Class]] {
    return values.extrema(property: { $0.span }, areInIncreasingOrder: <)
}

// TODO: Return array or arrays, not single array (dont call `.first!`)
func mostLeftPacked(_ values: [[Pitch.Class]]) -> [Pitch.Class] {
    assert(!values.isEmpty)
    guard values.count > 1 else { return values.first! }
    return values.sorted { $0.intervals.lexicographicallyPrecedes($1.intervals) }.first!
}

extension BidirectionalCollection where Element == Pitch.Class {

    // Invariant: self is sorted, is not empty
    var span: Pitch.Class {
        return last! - first!
    }
}

// FIXME: Move to lower level module

precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}

precedencegroup RightApplyPrecedence {
    associativity: right
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

precedencegroup LeftApplyPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

/// Compose | Applies one function to the result of another function to produce a third function.
infix operator <<< : CompositionPrecedence
infix operator >>> : CompositionPrecedence

/// Pipe Backward | Applies the function to its left to an argument on its right.
infix operator <| : RightApplyPrecedence

/// Pipe forward | Applies an argument on the left to a function on the right.
infix operator |> : LeftApplyPrecedence

/// Compose | Applies one function to the result of another function to produce a third function.
///
///     f : B -> C
///     g : A -> B
///     (f • g)(x) === f(g(x)) : A -> B -> C
public func <<< <A, B, C> (f: @escaping (B) -> C, g : @escaping (A) -> B) -> (A) -> C {
    return { x in
        return f(g(x))
    }
}

public func >>> <A, B, C> (f: @escaping (A) -> B, g : @escaping (B) -> C) -> (A) -> C {
    return { x in
        return g(f(x))
    }
}

func <| <A,B> (_ f: @escaping (A) -> B, _ x: A) -> B {
    return f(x)
}

func |> <A,B>(_ x: A, _ f: @escaping (A) -> B) -> B {
    return f(x)
}

