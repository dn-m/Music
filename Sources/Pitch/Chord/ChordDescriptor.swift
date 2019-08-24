//
//  ChordDescriptor.swift
//  Pitch
//
//  Created by James Bean on 10/23/18.
//

import DataStructures

/// Description of a simultaneity of pitches wherein the intervals between the pitches are
/// described.
///
/// **Example Usage**
///
///     let major: ChordDescriptor = [.M3, .m3]
///     let minor: ChordDescriptor = [.m3, .M3]
///     let diminished: ChordDescriptor = [.m3, .m3]
///     let augmented: ChordDescriptor = [.M3, .M3]
///
public struct ChordDescriptor {

    // MARK: - Instance Properties

    let intervals: [CompoundIntervalDescriptor]

    // MARK: - Initializers

    /// Creates a `ChordDescriptor` with the given `intervals`.
    public init(_ intervals: [CompoundIntervalDescriptor]) {
        self.intervals = intervals
    }
}

extension ChordDescriptor {

    // MARK: - Type Properties

    public static let major: ChordDescriptor = [.M3, .m3]
    public static let minor: ChordDescriptor = [.m3, .M3]
    public static let diminished: ChordDescriptor = [.m3, .m3]
    public static let augmented: ChordDescriptor = [.M3, .M3]
}

extension ChordDescriptor/*: RandomAccessCollectionWrapping*/ {

    // MARK: - RandomAccessCollectionWrapping

    /// - Returns: The `RandomAccessCollection` base of a `ChordDescriptor`.
    public var base: [CompoundIntervalDescriptor] {
        return intervals
    }
}

// FIXME: Reinstate RandomAccessCollectionWrapping conformance SR-11084"
extension ChordDescriptor: RandomAccessCollection {

    // MARK: - RandomAccessCollection

    public typealias Base = [CompoundIntervalDescriptor]

    /// Start index.
    ///
    /// - Complexity: O(1)
    ///
    public var startIndex: Base.Index {
        return base.startIndex
    }

    /// End index.
    ///
    /// - Complexity: O(1)
    ///
    public var endIndex: Base.Index {
        return base.endIndex
    }

    /// First element, if there is at least one element. Otherwise, `nil`.
    ///
    /// - Complexity: O(1)
    ///
    public var first: Base.Element? {
        return base.first
    }

    /// Last element, if there is at least one element. Otherwise, `nil`.
    ///
    /// - Complexity: O(1)
    ///
    public var last: Base.Element? {
        return base.last
    }

    /// Amount of elements.
    ///
    /// - Complexity: O(1)
    ///
    public var count: Int {
        return base.count
    }

    /// - Returns: `true` if there are no elements contained herein. Otherwise, `false`.
    ///
    /// - Complexity: O(1)
    ///
    public var isEmpty: Bool {
        return base.isEmpty
    }

    /// - Returns: The element at the given `index`.
    ///
    /// - Complexity: O(1)
    ///
    public subscript(position: Base.Index) -> Base.Element {
        return base[position]
    }

    /// - Returns: Index after the given `index`.
    ///
    /// - Complexity: O(1)
    public func index(after index: Base.Index) -> Base.Index {
        return base.index(after: index)
    }

    /// - Returns: Index before the given `index`.
    ///
    /// - Complexity: O(1)
    ///
    public func index(before index: Base.Index) -> Base.Index {
        return base.index(before: index)
    }
}

extension ChordDescriptor: ExpressibleByArrayLiteral {

    // MARK: ExpressibleByArrayLiteral

    /// Creates a `ChordDescriptor` with the given array literal of `CompoundIntervalDescriptor`
    /// values.
    public init(arrayLiteral intervals: CompoundIntervalDescriptor...) {
        self.intervals = intervals
    }
}
