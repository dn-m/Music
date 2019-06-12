//
//  ProportionTree.swift
//  Rhythm
//
//  Created by James Bean on 2/2/17.
//
//  Formalized by Brian Heim.
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import DataStructures
import Math

/// Similar to the proportional aspect of the `OpenMusic` `Rhythm Tree` structure.
public typealias ProportionTree = Tree<Int,Int>

extension Tree where Branch == Int, Leaf == Int {

    // MARK: - Instance Properties

    /// - Returns: `Tree` containing the inherited scale of each node contained herein.
    @inlinable
    public var scaling: Tree<Fraction, Fraction> {
        func traverse(_ tree: ProportionTree, accum: Fraction) -> Tree<Fraction, Fraction> {
            switch tree {
            case .leaf:
                return .leaf(accum)
            case .branch(let duration, let trees):
                let sum = trees.lazy.map { $0.value }.sum
                let scale = Fraction(duration, sum)
                return .branch(accum, trees.map { traverse($0, accum: accum * scale) })
            }
        }
        return traverse(self, accum: 1)
    }
    
    /// - Returns: A new `ProportionTree` in which the value of each node can be represented
    /// with the same subdivision-level (denominator).
    @inlinable
    public var normalized: ProportionTree {
        let siblingsReduced = reducingSiblings
        let parentsMatched = siblingsReduced.matchingParentsToChildren
        let distances = zip(siblingsReduced, parentsMatched, encodeDistance).propagated
        let updatedTree = zip(siblingsReduced, distances, decodeDuration)
        let childrenMatched = updatedTree.matchingChildrenToParents
        return childrenMatched
    }
    
    /// - returns: A new `ProportionTree` for which each level of sub-trees is at its most
    /// reduced level (e.g., `[2,4,6] -> [1,2,3]`).
    ///
    /// - note: In the case of parents with a single child, no reduction occurs.
    @usableFromInline
    var reducingSiblings: ProportionTree {
        func reduced(_ trees: [ProportionTree]) -> [ProportionTree] {
            let values = trees.lazy.map { $0.value }
            let reduced = values.lazy.map { $0 / values.gcd }
            return zip(trees, reduced).map { $0.updating(value: $1) }
        }
        guard case .branch(let value, let trees) = self, trees.count > 1 else { return self }
        return .branch(value, reduced(trees).map { $0.reducingSiblings })
    }

    /// - returns: `ProportionTree` with the values of parents matched to the closest
    /// power-of-two of the sum of the values of their children.
    ///
    /// There are two cases where action is required:
    ///
    /// - Parent is required scaled _up_ to match the sum of its children
    /// - Parent is required scaled _down_ to match the sum of its children
    @usableFromInline
    var matchingParentsToChildren: ProportionTree {
        func updateDuration(_ original: Int, _ children: [ProportionTree]) -> Int {
            let sum = children.lazy.map { $0.value }.sum
            let coefficient = original >> countTrailingZeros(original)
            return closestPowerOfTwo(coefficient: coefficient, to: sum)!
        }
        guard case .branch(let duration, let trees) = self else { return self }
        let newDuration = updateDuration(duration, trees)
        return .branch(newDuration, trees.map { $0.matchingParentsToChildren })
    }

    /// - returns: `ProportionTree` with the values of any leaves lifted to match any parents
    /// which have been lifted in previous stages of the normalization process.
    ///
    /// - note: That this is required perhaps indicates that propagation is not being handled
    /// correctly for trees of `height` 1.
    @usableFromInline
    var matchingChildrenToParents: ProportionTree {

        /// Only continue if we are a parent of only leaves.
        guard case .branch(let duration, let trees) = self, self.height == 1 else { return self }
        let sum = trees.lazy.map { $0.value }.sum

        /// If the duration of parent is greater than the sum of the children's values, our
        /// work is done.
        guard sum < duration else { return self }
        let multiplier = closestPowerOfTwo(coefficient: sum, to: duration)! / sum
        let newTrees = trees.map { $0.map { $0 * multiplier } }
        return .branch(duration, newTrees)
    }

    /// - returns: Relative duration value scaled by the given `distance`.
    @usableFromInline
    func decodeDuration(_ original: Int, _ distance: Int) -> Int {
        return Int(Double(original) * pow(2, Double(distance)))
    }

    /// - returns: Distance (in powers-of-two) from one relative durational value to another.
    @usableFromInline
    func encodeDistance(_ original: Int, _ new: Int) -> Int {
        return Int(log2(Double(new) / Double(original)))
    }
}

extension Tree where Branch == Int, Leaf == Int {

    // MARK: - Initializers

    /// Create a single-depth `ProportionTree` with the given root `duration` and child `durations`.
    @inlinable
    public init(_ duration: Int, _ durations: [Int]) {
        self = Tree.branch(duration, durations.lazy.map(Tree.leaf)).normalized
    }
}

/// Create a single-depth `ProportionTree` with the given root `duration` and child `durations`.
@inlinable
public func * (duration: Int, durations: [Int]) -> ProportionTree {
    return ProportionTree.init(duration,durations)
}

/// Tree recording the change (in degree of power-of-two) needed to normalize a 
/// `ProprtionTree`.
public typealias DistanceTree = Tree<Int,Int>

extension Tree where Branch == Int, Leaf == Int {

    /// - returns: `DistanceTree` with distances propagated up and down.
    ///
    /// - TODO: Not convinced by implementation of `propogateDown`.
    @usableFromInline
    var propagated: DistanceTree {

        /// Propagate up and accumulate the maximum of the sums of children values
        func propagatedUp(_ tree: DistanceTree) -> DistanceTree {
            guard case .branch(let value, let trees) = tree else { return tree }
            let newTrees = trees.map(propagatedUp)
            let max = newTrees.lazy.map { $0.value }.max()!
            return .branch(value + max, newTrees)
        }

        /// Takes in the original distance tree, and a distance tree which has already
        /// had its values propagated up to the root, as well as an inherited value which is passed
        /// along between levels.
        ///
        /// - note: Need to make inherited optional? // this smells
        func propagatedDown(_ original: DistanceTree, _ propagatedUp: DistanceTree, inherited: Int?)
            -> DistanceTree
        {
            switch (original, propagatedUp) {
            // If we are leaf,
            case (.leaf, .leaf):
                return .leaf(inherited!)
            // Replace value with inherited (if present), or already propagated
            case (.branch(let original, let oTrees), .branch(let propagated, let pTrees)):
                let value = inherited ?? propagated
                let subTrees = zip(oTrees, pTrees).map { o, p in
                    propagatedDown(o, p, inherited: value - original)
                }
                return .branch(value, subTrees)
            // Enforce same-shaped trees
            default:
                fatalError("Incompatible trees")
            }
        }

        return propagatedDown(self, propagatedUp(self), inherited: nil)
    }
}
