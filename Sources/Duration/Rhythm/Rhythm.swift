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
    public let leaves: [Leaf]
}

extension Rhythm {

    // MARK: - Associated Types

    /// The metrical identity of a given rhythmic leaf item.
    ///
    /// - "tied": if a leaf is "tied" over from the previous event (`.continuation`)
    /// - "rest": if a leaf is a "rest", a measured silence (`.instance(.rest)`)
    /// - "event": if a leaf is a measured non-silence (`.instance(.event(Element))`)
    ///
    public typealias Leaf = ContinuationOrInstance<AbsenceOrEvent<Element>>
}

extension Rhythm {

    // MARK: - Initializers

    /// Create a `Rhythm` with a given `durationTree` and given `leaves`.
    public init(_ durationTree: DurationTree, _ leaves: [Leaf]) {
        self.durationTree = durationTree
        self.leaves = leaves
    }

    /// Create a `Rhythm` with a given `duration` and `leaves.
    public init(_ duration: Duration, _ leaves: [(duration: Int, context: Leaf)]) {
        self.init(duration * leaves.map { $0.duration}, leaves.map { $0.context} )
    }

    /// Create an isochronic `Rhythm` with the given `duration` and the given `contexts`.
    public init(_ duration: Duration, _ contexts: [Leaf]) {
        self.init(duration * contexts.map { _ in 1 }, contexts)
    }

    /// Creates a `Rhythm` with a single event with the given `context`.
    public init(_ duration: Duration, _ context: Leaf) {
        self.init(duration * [1], [context])
    }
}

extension Rhythm {

    // MARK: - Instance Properties

    /// - Returns: An array of the `event` values contained herein.
    public var events: [Element] {
        var result: [Element] = []
        for leaf in leaves {
            switch leaf {
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

    /// - Returns: A sequence of tuples containing the `Duration` and `Leaf` information of each
    /// leaf item.
    public var duratedLeaves: AnySequence<(Duration,Leaf)> {
        return AnySequence(zip(durationTree.leaves,leaves))
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
        for (duration, leaf) in duratedLeaves {
            switch leaf {
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
            offset += duration
        }
        return result
    }

    /// - Returns: The effective duration of each `event`.
    public var lengths: [Duration] {
        return merge(duratedLeaves, into: [], tied: nil)
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
            leaves: leaves.map { leafMap($0,transform) }
        )
    }

    /// - Returns: `Rhythm` with each of the transforms applied to each of the event-containing
    /// leaves contained herein.
    public func mapEvents <U> (_ transforms: [(Element) -> U]) -> Rhythm<U> {

        func replace <S,T> (_ leaves: S, with transforms: T, into result: [Rhythm<U>.Leaf])
            -> [Rhythm<U>.Leaf] where
            S: Sequence, S.Element == Leaf, T: Sequence, T.Element == (Element) -> U
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
        return Rhythm<U>(durationTree, replace(leaves, with: transforms, into: []))
    }

    /// - Returns: `Rhythm` with the equivalent `durationTree` but with `event`-holding leaves
    /// replaced by the values contained in the given `leaves.`
    public func replaceEvents <U> (_ events: [U]) -> Rhythm<U> {
        return mapEvents(events.map { event in { _ in event } })
    }
}

// FIXME: Extend `Rhythm.Leaf` with a `map` once this is resolved:
// https://gist.github.com/mbrandonw/5e4f475c4e0e2caa1ce38c44531faf46
func leafMap <T,U> (_ leaf: Rhythm<T>.Leaf, _ transform: (T) -> U) -> Rhythm<U>.Leaf {
    switch leaf {
    case .continuation:
        return .continuation
    case .instance(let instance):
        return .instance(instance.map(transform))
    }
}

/// - Returns: The `Duration` values of the leaves of the given `rhythms`, by merging
/// `tied` leaves to their predecesors.
//
// FIXME: Make extension over `Sequence where Element == (Duration, Rhythm<T>.Leaf) when
// Swift supported parameterized extensions.
public func lengths <S,T> (of rhythms: S) -> [Duration] where S: Sequence, S.Element == Rhythm<T> {
    return merge(
        rhythms.flatMap { rhythm in zip(rhythm.durationTree.leaves,rhythm.leaves) },
        into: [],
        tied: nil
    )
}

// FIXME: Consider using `inout [Duration]` for `accum` re: performance.
func merge <S,T> (_ leaves: S, into accum: [Duration], tied: Duration?) -> [Duration]
    where S: Sequence, S.Element == (Duration, Rhythm<T>.Leaf)
{
    guard let (duratedLeaf, remaining) = leaves.destructured else { return accum + tied }
    let (duration, leaf) = duratedLeaf
    switch leaf {
    case .continuation:
        let tied = (tied ?? .zero) + duration
        return merge(remaining, into: accum, tied: tied)
    case .instance(let absenceOrEvent):
        let newAccum: [Duration]
        let newTied: Duration?
        switch absenceOrEvent {
        case .absence:
            newAccum = accum + tied + duration
            newTied = nil
        case .event:
            newAccum = accum + tied
            newTied = duration
        }
        return merge(remaining, into: newAccum, tied: newTied)
    }
}

/// - Returns: `Rhythm` with the given `DurationTree` and `Rhythm.Leaf.Kind` values.
public func * <Element> (lhs: DurationTree, rhs: [Rhythm<Element>.Leaf]) -> Rhythm<Element> {
    return Rhythm(lhs, rhs)
}

/// - Returns: `.continuation` with generic context provided by the external environment.
public func tie <T> () -> Rhythm<T>.Leaf {
    return .continuation
}

/// - Returns: `.instance(.absence)` with generic context provided by the external environment.
public func rest <T> () -> Rhythm<T>.Leaf {
    return .instance(.absence)
}

/// - Returns: `.instance(.event(T))` wrapping the given `value`.
public func event <T> (_ value: T) -> Rhythm<T>.Leaf {
    return .instance(.event(value))
}

extension Rhythm: Equatable where Element: Equatable { }
