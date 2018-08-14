# Rhythm

The `Rhythm` module defines basic structures for describing a hierarchical organization of metrical duration.

The building blocks of the `Rhythm` module are the `MetricalDurationTree`, `MetricalContext`, and `Rhythm`.

### MetricalDurationTree

`MetricalDurationTree` is a `typealias` for a [`Tree`](https://github.com/dn-m/Structure/blob/master/Sources/DataStructures/Tree.swift) with `MetricalDuration` values for its `Branch` and `Leaf` generic type arguments.

### MetricalContext

`MetricalContext` is a `typealias` for `ContinuationOrInstance<AbsenceOrEvent<Element>>`, for which `Element` is completely generic.

It is a composition of two types, `AbsenceOrEvent` and `ContinuationOrInstance`.

#### AbsenceOrEvent<Element>

The `AbsenceOrEvent` is a generic enum which is very similar to the `Optional` enum in the Swift Standard Library. In more musically-concrete terms, this enum describes whether a metrical item is a "rest" (`.absence`) or a "note" (`.event(Element)`).

#### ContinuationOrInstance<Element>

The `ContinuationOrInstance` is a generic enum which is very similar to the `Optional` enum in the Swift Standard Library. In more musically-concrete terms, this enum describes whether a metrical item is "tied" over from the previous item (`.continuation`), or if it is a "rest" or a "note" (`.instance(Element)`).

This `MetricalContext` provides a strong type to represent all of the possible scenerios within a `Rhythm`, and no more.

### Rhythm<Element>

A `Rhythm` is the composition of a `MetricalDurationTree`, and an array of `Rhythm.Leaf` values.

### Rhythm.Leaf

The `Rhythm.Leaf` structure is composition of a `MetricalDuration` and a `MetricalContext`.