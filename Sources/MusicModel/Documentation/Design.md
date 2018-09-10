# Model Design

This document serves as an enumeration of design goals for the `Model` object in the `MusicModel` module.

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

Any query of musical information will exist within some interval of musical time (even if this interval is equivalent to that of the entire work). As such, it is of critical importance to provide the music information in a given interval as performantly as possible. Identifiers for each attribute (piece of musical information) are stored by their fractional interval in an `IntervalSearchTree<Fraction,Set<AttributeID>>`.

The `IntervalSearchTree` structure is implemented as an augmented `AVLTree`, which provides better lookup performance than a red-black tree and worse insertion and removal performance.

### Query By Voice

Identifiers for each attribute are stored in a `Dictionary<Voice,Set<AttributeID>>`.

### Query By Type

Identifiers for each attribute are stored in a `Dictionary<Metatype,Set<AttributeID>>`.