# Model Design

This document serves as an enumeration of design goals for the `Model` object in the `MusicModel` module.

## Basic Types

### Performer

The model of an agent (actor) able to actuate musical events. A `Performer` may perform through one or more `Instrument` values.

### Instrument

The model of an object or system with which musical events can be actuated. An `Instrument` may be performed through by one or more `Performer` values.

### Voice

A single thread of actuation from a `Performer` through an `Instrument`. In the case that a `Performer`-`Instrument` pair is polyphonic and different "voices" of this polyphony occur in non-identical intervals of musical time, these "voices" must be represented as different `Voice` structures

### Rhythm

A `Rhythm` is a hierarchical structuring of time, coupled with a sequence of metrical contexts which indicate whether a rhythmical leaf item is a "rest", "tie", or "event". A `Rhythm` contains only the musical information of a single `Voice`.

### Event

An `Event` is a collection of `Attribute` values which are performed by a single `Voice` in a given interval of musical time.

### Attribute

An `Attribute` is any bit of information which describes a musical `Event` (`Pitch`, `Dynamic`, `Articulation`, `Slur`, etc.).

## API

The `Model` object functions as a domain-specific in-memory database for abstract musical elements. There are three primary queries which the `Model` is designed to support.

### `attributes (in interval: Range<Fraction>) -> Set<AttributeID>`

> Complexity: O(log *n + m*), where *n* is the total amount of intervals, and *m* is the number of intervals produced by the query.

Returns all of the identifiers of the attributes occurring in the given `interval`.

### `attributes (by voice: Voice) -> Set<AttributeID>`

> Complexity: O(*1*)

Returns all of the identifiers of the attributes performed by the given `voice`.

### `attributes () <T> -> Set<AttributeID>`

> Complexity: O(*1*)

Returns all of the attributes of the given type `T`.

## Implementation

The primary use cases for this musical model are the queries stated above. The understanding is that the model will be built roughly once, but potentially queried many times. Thus, a priority of fast lookup is made over fast construction.

### Query By Interval

Any query of musical information will exist within some interval of musical time (even if this interval is equivalent to that of the entire work). As such, it is of critical importance to provide the music information in a given interval as performantly as possible. Identifiers for each event (piece of musical information performed by a single voice at a single offset) are stored by their fractional interval.

> The `IntervalSearchTree` structure is implemented as an augmented `AVLTree`, which provides better lookup performance than a red-black tree yet worse insertion and removal performance. These trade-offs seem reasonable given the performance requirements stated above.

### Query By Voice

Identifiers for each event are stored in a `Dictionary<VoiceID,IntervalSearchTree<Fraction,Set<EventID>>>`.

### Query By Type

Identifiers for each attribute can be queried by their dynamic type with the use of the [`Metatype`](https://github.com/dn-m/Structure/blob/master/Sources/DataStructures/Metatype.swift) wrapper struct.