//
//  Rhythm.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import DataStructures
import Math

/// Hierarchical organization of metrical durations and their activation contexts.
///
/// The `Rhythm` structure composes a `DurationTree` and an array of `Leaf` values, each of which
/// represent the metrical context (e.g., "tied", "rest", or "event") of a `Duration` in the
/// `leaves` of the `durationTree.
///
/// **Example Usage**
///
/// First, construct a `DurationTree`:
///
///     let durations: DurationTree = .branch(Duration(4,8), [
///         .leaf(Duration(1,8)),
///         .leaf(Duration(1,8)),
///         .leaf(Duration(2,8)),
///         .leaf(Duration(1,8))
///     ])
///     // =>     4/>8  (5:4 tuplet)
///     //     /  |  |  \
///     // 1/>8 1/>8 2/>8 1/>8
///
/// Then, construct an array of `Leaf` values:
///
///     let leaves: [Duration<Int>.Leaf] = [
///         rest(),
///         event(1),
///         tie(),
///         rest()
///     ]
///     // => [<>,<1>,<->,<>]
///
/// Now, you can put them together:
///
///     let rhythm = Rhythm(durations,leaves) // =>
///     //        4/>8
///     //     /  |  |  \
///     // 1/>8 1/>8 2/>8 1/>8
///     //  <>   <1> <->   <>
///
/// It is easy to transform the `event` values contained in a `Rhythm`:
///
///     let more = rhythm.map { $0 + 1 } // =>
///     //        4/>8
///     //     /  |  |  \
///     // 1/>8 1/>8 2/>8 1/>8
///     //  <>   <2> <->   <>
///
//
// FIXME: Use graffle png instead of ASCII art
public struct Rhythm <Element> {

    /// Hierarchical representation of metrical durations.
    public let durationTree: DurationTree

    /// Leaf items containing metrical context.
    public var leaves: [Leaf]
}

extension Rhythm {

    // MARK: - Type Aliases

    /// The metrical identity of a given rhythmic leaf item.
    ///
    /// - "tied": if a leaf is "tied" over from the previous event (`.continuation`)
    /// - "rest": if a leaf is a "rest", a measured silence (`.instance(.rest)`)
    /// - "event": if a leaf is a measured non-silence (`.instance(.event(Element))`)
    ///
    public typealias Context = ContinuationOrInstance<AbsenceOrEvent<Element>>
}

extension Rhythm {

    // MARK: - Nested Types

    /// A pair of a `Duration` and `Context` representing a single leaf of a `Rhythm` structure.
    public struct Leaf {
        public let duration: Duration
        public var context: Context
    }
}

extension Rhythm {

    // MARK: - Initializers

    /// Create a `Rhythm` with a given `durationTree` and given `leaves`.
    public init(_ durationTree: DurationTree, _ leaves: [Context]) {
        self.durationTree = durationTree
        self.leaves = zip(durationTree.leaves,leaves).map(Leaf.init)
    }

    /// Create a `Rhythm` with a given `duration` and `leaves.
    public init(_ duration: Duration, _ leaves: [(duration: Int, context: Context)]) {
        self.init(duration * leaves.map { $0.duration }, leaves.map { $0.context} )
    }

    /// Create an isochronic `Rhythm` with the given `duration` and the given `contexts`.
    public init(_ duration: Duration, _ contexts: [Context]) {
        self.init(duration * contexts.map { _ in 1 }, contexts)
    }

    /// Creates a `Rhythm` with a single event with the given `context`.
    public init(_ duration: Duration, _ context: Context) {
        self.init(duration * [1], [context])
    }
}

extension Rhythm {

    // MARK: - Instance Properties

    /// - Returns: An array of the `event` values contained herein.
    public var events: [Element] {
        var result: [Element] = []
        for leaf in leaves {
            switch leaf.context {
            case .continuation:
                continue
            case .instance(let absenceOrEvent):
                switch absenceOrEvent {
                case .absence:
                    continue
                case .event(let event):
                    result.append(event)
                }
            }
        }
        return result
    }

    /// - Returns: A sequence of tuples containing the `Duration` and `Element` information of
    /// event.
    public var duratedEvents: AnySequence<(Duration,Element)> {
        return AnySequence(zip(lengths,events))
    }

    /// - Returns: The durational offsets of the event-containing leaves.
    public var eventOffsets: [Duration] {
        var result: [Duration] = []
        var offset: Duration = .zero
        for leaf in leaves {
            switch leaf.context {
            case .continuation:
                continue
            case .instance(let absenceOrEvent):
                switch absenceOrEvent {
                case .absence:
                    continue
                case .event:
                    result.append(offset)
                }
            }
            offset += leaf.duration
        }
        return result
    }

    /// - Returns: The effective duration of each `event`.
    @inlinable
    public var lengths: [Duration] {
        return merge(leaves)
    }

    /// - Returns: The indices within `leaves` which contain events (not ties or rests).
    public var eventIndices: [Int] {
        var result: [Int] = []
        for (index,leaf) in leaves.enumerated() {
            if case .instance(let absenceOrEvent) = leaf.context, case .event = absenceOrEvent {
                result.append(index)
            }
        }
        return result
    }
}

extension Rhythm {

    // MARK: - Instance Methods

    /// - Returns: `Rhythm` with each of its `event` (i.e., `.instance(.event(Element))`) values
    /// updated by the given `transform`.
    ///
    /// - Each `.continuation` remains as such
    /// - Each `.instance(.rest)` remains as such
    /// - Each `.instance(.event(T))` is transformed to a `.instance(.event(U))`
    ///
    public func map <U> (_ transform: @escaping (Element) -> U) -> Rhythm<U> {
        return Rhythm<U>(
            durationTree: durationTree,
            leaves: leaves.map { leaf in
                Rhythm<U>.Leaf(duration: leaf.duration, context: leafMap(leaf.context, transform))
            }
        )
    }

    /// - Returns: `Rhythm` with each of the transforms applied to each of the event-containing
    /// leaves contained herein.
    public func mapEvents <U> (_ transforms: [(Element) -> U]) -> Rhythm<U> {

        func replace <S,T> (_ leaves: S, with transforms: T, into result: [Rhythm<U>.Context])
            -> [Rhythm<U>.Context] where
            S: Sequence, S.Element == Context, T: Sequence, T.Element == (Element) -> U
        {
            guard let (leaf,remainingLeaves) = leaves.destructured else { return result }
            switch leaf {
            case .continuation:
                return replace(remainingLeaves, with: transforms, into: result + [.continuation])
            case .instance(let absenceOrEvent):
                switch absenceOrEvent {
                case .absence:
                    return replace(remainingLeaves,
                       with: transforms,
                       into: result + [.instance(.absence)]
                    )
                case .event(let event):
                    guard let (transform,remainingTransforms) = transforms.destructured else {
                        fatalError("Cannot replace leaves with: \(transforms)")
                    }
                    return replace(remainingLeaves,
                       with: remainingTransforms,
                       into: result + [.instance(.event(transform(event)))]
                    )
                }
            }
        }
        return Rhythm<U>(
            durationTree,
            replace(leaves.lazy.map { $0.context }, with: transforms, into: [])
        )
    }

    /// - Returns: `Rhythm` with the equivalent `durationTree` but with `event`-holding leaves
    /// replaced by the values contained in the given `leaves.`
    public func replaceEvents <U> (_ events: [U]) -> Rhythm<U> {
        return mapEvents(events.map { event in { _ in event } })
    }
}

// FIXME: Extend `Rhythm.Context` with a `map` once this is resolved:
// https://gist.github.com/mbrandonw/5e4f475c4e0e2caa1ce38c44531faf46
func leafMap <T,U> (_ leaf: Rhythm<T>.Context, _ transform: (T) -> U) -> Rhythm<U>.Context {
    switch leaf {
    case .continuation:
        return .continuation
    case .instance(let instance):
        return .instance(instance.map(transform))
    }
}

/// - Returns: The `Duration` values of the leaves of the given `rhythms`, by merging
/// `tied` leaves to their predecesors.
@inlinable
public func lengths <S,T> (of rhythms: S) -> [Duration] where S: Sequence, S.Element == Rhythm<T> {
    return merge(rhythms.flatMap { $0.leaves })
}


// FIXME: Use Generalize Existentials when supported by Swift.
@usableFromInline
func merge <S,T> (_ leaves: S) -> [Duration] where S: Sequence, S.Element == Rhythm<T>.Leaf {
    var result: [Duration] = []
    var tied: Duration?
    for leaf in leaves {
        switch leaf.context {
        case .continuation:
            tied = (tied ?? .zero) + leaf.duration
        case .instance(let absenceOrEvent):
            switch absenceOrEvent {
            case .absence:
                if let tied = tied { result += [tied, leaf.duration] }
                tied = nil
            case .event:
                if let tied = tied { result += [tied] }
                tied = leaf.duration
            }
        }
    }
    if let tied = tied { result += [tied] }
    return result
}

/// - Returns: `Rhythm` with the given `DurationTree` and `Rhythm.Context.Kind` values.
public func * <Element> (lhs: DurationTree, rhs: [Rhythm<Element>.Context]) -> Rhythm<Element> {
    return Rhythm(lhs, rhs)
}

/// - Returns: `.continuation` with generic context provided by the external environment.
public func tie <T> () -> Rhythm<T>.Context {
    return .continuation
}

/// - Returns: `.instance(.absence)` with generic context provided by the external environment.
public func rest <T> () -> Rhythm<T>.Context {
    return .instance(.absence)
}

/// - Returns: `.instance(.event(T))` wrapping the given `value`.
public func event <T> (_ value: T) -> Rhythm<T>.Context {
    return .instance(.event(value))
}

extension Rhythm.Leaf: Equatable where Element: Equatable { }
extension Rhythm: Equatable where Element: Equatable { }

