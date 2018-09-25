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

## Musings on type-safety and extensibility

The `Model` class serves as a database of the abstract musical information in a single musical work. Just about anything can be considered musical information, and as such the database needs to be flexible with regards to storing a wide variety of types, definable downstream from this package. A significant goal of this project, though, is to utilize Swift's strong type system to the greatest extent possible, as such a type system can enforce that certain states are supported at compile time (e.g., exhaustive switching over enum cases, mandatory implementation of protocol requirements, etc.). The desire for strong typing is slightly at-odds, however, with the desire for downstream customizability.

### Most Flexible

The most flexible way to implement is to store all values as `Any`, reconstituting their type upon expression via conditional downcasting. For example, consider the following collection of musical information:

```Swift
let event: [Any] = [Pitch(60), Dynamic.fff, Articulation.staccato]
```

In the context of representing these items, a renderer can conditionally downcast each supported type:

```Swift
for item in event {
    if let p = item as? Pitch { ... }
    else if let d = item as? Dynamic { ... }
    else if let a = item as? Articulation { ... }
    else { print("Unsupported item: \(item)") }
}
```

This is very convenient, as a renderer can incrementally add support for types supported by the `Model`.

However, a composer may decide to include a parameterized `FireCannon` technique into a new piece.

```Swift
let boom: [Any] = [FireCannon(vector: ..., gunpowder: ...), Dynamic.fffff, Articulation.accent]
```

There is nothing communicated (by the compiler) to notational renderers or audio engines downstream to ensure that such new techniques _can_ be supported, let alone that they are supported.

#### Baby steps in the right direction

A protocol-oriented (or even object-oriented) approach could be injected:

```Swift
protocol MusicItem { ... }
extension Pitch: MusicItem { }
extension Dynamic: MusicItem { }
extension Articulation: MusicItem { }
```

> Most computational models of music from the last two decades employ an object-oriented approach (see: Abjad, GUIDO, Music21, etc.)

A model could then be represented as such:

```Swift
let tone: [MusicItem] = [Pitch(60), Dynamic.fff, Articulation.staccato]
```

Ultimately, though, there is no more type-safety than when declaring all types as `Any`, as Swift has no concept analogous to Scala's [sealed traits](https://underscore.io/blog/posts/2015/06/02/everything-about-sealed.html). As we will see in the next section, this may not desirable, anyway.

### Most Safe

On the other side of the spectrum from the type-unsafe world of `Any` and conditional downcasting are enums.

```Swift
enum MusicalItem {
    case pitch(Pitch)
    case dynamic(Dynamic)
    case articulation(Articulation)
}
```

The event described above could then be re-represented as:

```Swift
let event: [MusicalItem] = [.pitch(Pitch(60)), .dynamic(.fff), .articulation(.staccato)]
```

Upon representing the event, the Swift compiler enforces that we handle each case:

```Swift
for item in event {
    switch item {
    case .pitch(let pitch): ...
    case .dynamic(let dynamic): ...
    case .articulation(let articulation): ...
    }
}
```

If the composer deems the `FireCanon` type critical to their musical practice, a case can be added to `MusicalItem`:

```Swift
enum MusicalItem {
    case pitch(Pitch)
    case dynamic(Dynamic)
    case articulation(Articulation)
    case fireCannon(FireCannon)
}
```

A downstream renderer would not compile because it does not handle all specified cases.

```Swift
for item in event {
    switch item {
    case .pitch(let pitch): ...
    case .dynamic(let dynamic): ...
    case .articulation(let articulation): ...
    // error: Switch must be exhaustive
    }
}
```

### Final Tagless Style

There are two goals for this abstract model of musical information: that it is type-safe, and arbitrarily extensible by developers downstream.

An interesting avenue for research into solving this problem (the [expression problem](https://en.wikipedia.org/wiki/Expression_problem)) is the use of the "final tagless style". The final tagless style in Swift, uses static, `Self`-returning, methods required by composable protocols instead of enums or class hierarchies.

This is a compelling approach because protocol requirements are enforced by the compiler (satisfying our type-safety goal) and cases can be extended arbitrarily (satistying our exstensibility goal).

Let's try to build up our `MusicalItem` value this way:

```Swift
protocol MusicalItem {
    static func pitch(_: Pitch) -> Self
    static func dynamic(_: Dynamic) -> Self
    static func articulation(_: Articulation) -> Self
}
```

We can create a variety of concrete renderers, one of which could be:

```Swift
struct Renderer: MusicalItem {
    static func pitch(_ pitch: Pitch) -> Renderer { ... }
    static func articulation(_ articulation: Articulation) -> Renderer { ... }
    static func dynamic(_ dynamic: Dynamic) -> Renderer { ... }
    static func collection([Self]) -> Renderer { ... }
}
```

> There is still some mystery about the actual implementation of `Renderer` ...

Lastly, we need to build up a function which ties down the generic constraint of a `MusicalItem`-conforming type:

```Swift
func musicalItem <M: MusicalItem> () -> M {
    return M.collection(...)
}
```

```Swift
let renderer: Renderer = musicalItem()
```

> More mystery

What is compelling here, though, is the ability to add a `FireCanon` type, and a renderer which can explicitly opt-in to representing the new type.

```Swift
protocol CannonFiring {
    static func fireCannon(_ fireCannon: FireCannon) -> Self
}
```

```Swift
extension Renderer: CannonFiring {
    static func fireCannon(_ fireCannon: FireCannon) -> Renderer { ... }
}
```

```Swift
func musicalItemAndCannonFiring <M: MusicalItem & FireCannon> () -> M {
    return M.collection(...)
}
```

```Swift
let renderer: Renderer = musicalItem()
```

In the end, each renderer knows explicitly what it needs to represent, in a way that is enforced by the compiler, yet each renderer can be extended incrementally in order to support new cases.

### Alleys for further discussion

Such a model like final tagless style (if this were to work), could be applied to different dimensions of this model (e.g., there could be an entire constellation of different articulation types for different instruments, in different styles, for different time periods, etc.).

It should also be noted that there is an entire organizational layer between this abstract representation and the actual graphical rendering (see: [dn-m/NotationModel](https://github.com/dn-m/NotationModel)). 

> This could make this more awkward, or more powerful, I'm not sure yet.

