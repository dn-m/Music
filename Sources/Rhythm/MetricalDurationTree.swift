//
//  MetricalDurationTree.swift
//  Rhythm
//
//  Created by James Bean on 2/7/17.
//
//

import Algebra
import DataStructures
import Math
import MetricalDuration

// FIXME: Move to `MetricalDuration`

/// Tree containing `MetricalDuration` values.
public typealias MetricalDurationTree = Tree<MetricalDuration, MetricalDuration>

/// - Note: Use extension MetricalDurationTree when Swift allows it.
extension Tree where Branch == MetricalDuration, Leaf == MetricalDuration {

    /// `MetricalDuration` value of this `MetricalDurationTree` node.
    public var duration: MetricalDuration {
        switch self {
        case .leaf(let duration):
            return duration
        case .branch(let duration, _):
            return duration
        }
    }

    /// - Returns: `Tree` containing the inherited scale of each node contained herein.
    public var scaling: Tree<Fraction,Fraction> {
        return map { $0.numerator }.scaling
    }

    /// - Returns: `MetricalDurationTree` with the durations scaled by context.
    public var scaled: Tree<Fraction,Fraction> {
        return zip(self, scaling) { duration, scaling in (Fraction(duration) * scaling).reduced }
    }

    /// - returns: Array of tuples containing the scaled offset from the start of this
    /// `MetricalDurationTree`.
    ///
    /// - TODO: Change to concrete offsets.
    /// - TODO: Refactor to 
    /// `concreteOffsets(startingAt: MetricalDuration, in structure: Meter.Structure)`
    public var offsets: [Fraction] {
        return scaled.leaves.accumulatingSum
    }

    /// Create a `MetricalDurationTree` with the beat values of the given `proportionTree`
    /// with the given `subdivision`.
    ///
    /// - note: Ensure the given `proportionTree` has been normalized.
    public init(_ subdivision: Int, _ proportionTree: ProportionTree) {
        self = proportionTree.map { $0 /> subdivision }
    }

    /// Create a `MetricalDurationTree` with the given `metricalDuration` as the value of the
    /// root node, and the given `proportions` scaled appropriately.
    public init(_ metricalDuration: MetricalDuration, _ proportionTree: ProportionTree) {

        let beats = metricalDuration.numerator
        let subdivision = metricalDuration.denominator
        
        // Update proportion tree
        let multiplier = lcm(beats, proportionTree.value) / proportionTree.value
        let scaled = proportionTree.map { $0 * multiplier }
        let normalized = scaled.normalized

        // Update subdivision given updated proportions
        let quotient = Double(normalized.value) / Double(beats)
        let newSubdivision = Int(Double(subdivision) * Double(quotient))

        self.init(newSubdivision, normalized)
    }
}

/// - returns: A `MetricalDurationTree` with the given `subdivision` applied to each node.
public func * (_ subdivision: Int, proportions: [Any]) -> MetricalDurationTree {
    return MetricalDurationTree(subdivision, ProportionTree(proportions))
}

/// - returns: A `MetricalDurationTree` with the given `metricalDuration` as the value of the
/// root node, and the given `proportions` scaled appropriately.
public func * (_ metricalDuration: MetricalDuration, _ proportions: [Any])
    -> MetricalDurationTree
{
    return MetricalDurationTree(metricalDuration, ProportionTree(proportions))
}

/// - returns: A single-depth `MetricalDurationTree` with the given `metricalDuration` as the 
/// value of the root node, and the given `proportions` mapped accordingly as the children.
///
/// If an empty array is given, a single child is created with the same `MetricalDuration`
/// value as the root.
public func * (_ metricalDuration: MetricalDuration, _ proportions: [Int])
    -> MetricalDurationTree
{

    if proportions.isEmpty {
        return .branch(metricalDuration, [.leaf(metricalDuration)])
    }

    let beats = metricalDuration.numerator
    let proportionTree = ProportionTree([beats, proportions])
    return MetricalDurationTree(metricalDuration, proportionTree)
}
