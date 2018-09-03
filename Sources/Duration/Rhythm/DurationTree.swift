//
//  DurationTree.swift
//  Rhythm
//
//  Created by James Bean on 2/7/17.
//
//

import Algebra
import DataStructures
import Math

/// Tree containing `Duration` values.
public typealias DurationTree = Tree<Duration,Duration>

extension Tree where Branch == Duration, Leaf == Duration {

    // MARK: - Initializers

    /// Create a `DurationTree` with the beat values of the given `proportionTree`
    /// with the given `subdivision`.
    ///
    /// - note: Ensure the given `proportionTree` has been normalized.
    @inlinable
    public init(_ subdivision: Int, _ proportionTree: ProportionTree) {
        self = proportionTree.map { $0 /> subdivision }
    }

    /// Create a `DurationTree` with the given `duration` as the value of the
    /// root node, and the given `proportions` scaled appropriately.
    @inlinable
    public init(_ duration: Duration, _ proportionTree: ProportionTree) {

        let beats = duration.beats
        let subdivision = duration.subdivision

        // Update proportion tree
        let multiplier = lcm(beats, proportionTree.value) / proportionTree.value
        let scaled = proportionTree.map { $0 * multiplier }
        let normalized = scaled.normalized

        // Update subdivision given updated proportions
        let quotient = Double(normalized.value) / Double(beats)
        let newSubdivision = Int(Double(subdivision) * quotient)

        self.init(newSubdivision, normalized)
    }
}

/// - Note: Use extension DurationTree when Swift allows it.
extension Tree where Branch == Duration, Leaf == Duration {

    // MARK: - Instance Properties

    /// `Duration` value of this `DurationTree` node.
    @inlinable
    public var duration: Duration {
        switch self {
        case .leaf(let duration):
            return duration
        case .branch(let duration, _):
            return duration
        }
    }

    /// - Returns: `Tree` containing the inherited scale of each node contained herein.
    @inlinable
    public var scaling: Tree<Fraction,Fraction> {
        return map { $0.beats }.scaling
    }

    /// - Returns: `DurationTree` with the durations scaled by context.
    @inlinable
    public var scaled: Tree<Fraction,Fraction> {
        return zip(self, scaling) { duration, scaling in (Fraction(duration) * scaling).reduced }
    }

    /// - returns: Array of tuples containing the scaled offset from the start of this
    /// `DurationTree`.
    ///
    /// - TODO: Change to concrete offsets.
    /// - TODO: Refactor to 
    /// `concreteOffsets(startingAt: Duration, in structure: Meter.Structure)`
    @inlinable
    public var offsets: [Fraction] {
        return scaled.leaves.accumulatingSum
    }
}

/// - Returns: A `DurationTree` with the given `subdivision` applied to each node.
@inlinable
public func * (_ subdivision: Int, proportions: [Int]) -> DurationTree {
    return DurationTree(subdivision, ProportionTree(subdivision,proportions))
}

/// - Returns: A single-depth `DurationTree` with the given `duration` as the 
/// value of the root node, and the given `proportions` mapped accordingly as the children.
///
/// If an empty array is given, a single child is created with the same `Duration`
/// value as the root.
@inlinable
public func * (_ duration: Duration, _ proportions: [Int]) -> DurationTree {
    if proportions.isEmpty { return .branch(duration, [.leaf(duration)]) }
    let beats = duration.beats
    let proportionTree = ProportionTree(beats, proportions)
    return DurationTree(duration, proportionTree)
}
