# Duration

The `Duration` module defines basic structures for describing a symbolic representation of time by hierarchical subdivision. The building blocks of the `Duration` module are the `Duration`, `Rhythm`, `Tempo`, and `Meter` structures.

## Duration

The `Duration` structure is a [`Rational`](https://github.com/dn-m/Math/blob/master/Sources/Math/Rational.swift) type, defined by its numerator (`Beats`) over its power-of-two denominator (`Subdivision`). A `Duration` can be instantiated with a `Beats` and `Subdivision`.

```Swift
let dur = Duration(5,32)
```

> Warning: The denominator _must_ be a power-of-two, otherwise your program will crash.

```Swift
let notDur = Duration(4,17) // boom
```

A `Duration` can be created with a shorthand via the `/>` operator.

```Swift
let dur = 17/>64
```

## Rhythm


### ProportionTree

A `ProportionTree` is a `typealias` for `Tree<Int,Int>`, from the [`dn-m/Structure/DataStructures`](https://dn-m.github.io/Packages/Structure/Modules/DataStructures/index.html) module, which provides a hierarchical model of relative durational values without a specificed `Duration` container size. A `ProportionTree` can be as simple as a pair of eighth notes,

```Swift
let eighthPair: ProportionTree = .branch(1, [1,1])
```

or as complicated as a deeply nested tuplet.

```Swift
let nested: ProportionTree = .branch(1, [
    .branch(2, [
        .branch(2, [
            .leaf(1),
            .leaf(1)
        ]),
        .leaf(3)
    ]),
    .branch(4, [
        .leaf(3),
        .leaf(4),
        .branch(6, [
            .leaf(1),
            .leaf(1)
        ]),
        .leaf(2),
        .branch(2, [
            .leaf(3),
            .leaf(5)
        ])
    ]),
    .branch(3, [
        .leaf(2),
        .leaf(4),
        .branch(1, [
            .leaf(16),
            .leaf(17)
        ])
    ])
])
```

> Note: This type is useful for composing up arbitrarily simple or complex rhythms without having to commit to an overall `Duration`, or having to normalize the subdivision relationships between all of the nodes.

### DurationTree

A `DurationTree` is a `typealias` for `Tree<Duration,Duration>`, from the [`dn-m/Structure/DataStructures`](https://dn-m.github.io/Packages/Structure/Modules/DataStructures/index.html) module.

A `DurationTree` is often not needed to be created by user, but is often the composition of a `Duration` container size and a `ProportionTree`.

```Swift
let proportions: ProportionTree = .branch(1, [1,2,4])
let duration = 13/>64
let durationTree = DurationTree(duration, proportions)
```

The beat and subdivision values of each node of the resulting `DurationTree` will be normalized automatically

```Swift
durationTree // => .branch(13/>64, [
    .leaf(2/>64),
    .leaf(4/>64),
    .leaf(8/>64)
])
```

for a resulting tuplet ratio of `14:13`.

### Rhythm.Leaf

A `Rhythm.Leaf` models the metrical identity of a given rhythmic leaf item. It is a `typealias` for `ContinuationOrInstance<AbsenceOrEvent<Element>>`.

 - `.continuation` (i.e., a leaf is "tied" over from the previous event)
 - `.instance(.rest)` (i.e., a leaf is a "rest", a measured silence)
 - `.instance(.event(Element))` (i.e., a leaf is a measured non-silence)

#### ContinuationOrInstance<Element>

`ContinuationOrInstance` is a two-case generic enum similar to the `Optional` enum of the Standard Library, which describes whether a rhythmic item is:

- a `.continuation` (i.e., "tied-over" from its preceeding item), or
- an `.instance(Element)` (i.e., an action occuring).

#### AbsenceOrEvent<Element>

`AbsenceOrEvent` is a two-case generic enum similar to the `Optional` enum of the Standard Library, which describes whether a rhythmic item is:

- an `.absence` (i.e., a "rest"), or
- an `.event(Element)` (i.e., a "note").

## Rhythm
 
A `Rhythm` is the composition of a `DurationTree` and an array of `Rhythm.Leaf` values (with a length equivalent to the leaves of the `durationTree`). The `Rhythm.Leaf` values can store any value generically.

We can decorate the `durationTree` above like so:

```Swift
let rhythm = Rhythm<String>(durationTree, [
    .instance(.absence),        // rest
    .instance(.event("BANG")),  // start event
    .continuation               // tied from previous event
])
```

## Meter

Like a `Duration`, a `Meter` is a `Rational` type, used for defining the metrical context of measure.

You can create a "common time" meter,

```Swift
let meter = Meter(4,4)
```

or maybe something a little more fun.

```Swift
let meter = Meter(31,128)
```

## Tempo

A `Tempo` is the definition of a pulse occurring at a given frequency (`beatsPerMinute`) at a given `Subdivision` level (e.g., quarter, sixteenth, etc.).

```Swift
let stayinAlive = Tempo(100, subdivision: 4) // remember this for CPR
```

### Tempo.Interpolation.Easing

A `Tempo.Interpolation.Easing` specifies the curve of a `Tempo.Interpolation`. 

- `linear`
- `powerIn`
- `powerInOut`
- `exponentialIn`
- `sineInOut`

### Tempo.Interpolation

A `Tempo.Interpolation` defines a transition between two `Tempo` values, over a given `length`, with a specified `easing`.

```Swift
let startTempo = Tempo(24, subdivision: 4)
let endTempo = Tempo(192, subdivision: 8)
let interpolation = Tempo.Interpolation(
    start: startTempo,
    end: endTempo,
    length: Fraction(37,4),
    easing: .sineInOut
)  
```
> Note: Subdivision values needn't be the same.

### Tempo.Interpolation.Fragment

A `Tempo.Interpolation.Fragment` is a portion of a `Tempo.Interpolation` within a given `range`.

```Swift
let startTempo = Tempo(24)
let endTempo = Tempo(72) 
let interpolation = Tempo.Interpolation(
    start: startTempo,
    end: endTempo,
    length: Fraction(13,4)
)
let fragment = Tempo.Interpolation.Fragment(
    interpolation, 
    in: Fraction(5,4) ..< Fraction(11,4)
)
```

> Note: The default `subdivision` value is `4` and the default `easing` value is `.linear`.

### Tempo.Interpolation.Collection

A `Tempo.Interpolation.Collection` defines a contiguous collection of `Tempo.Interpolation.Fragment` values, which are indexed by the offset `Fraction` value.

#### Tempo.Interpolation.Collection.Builder

A helper class `Tempo.Interpolation.Collection.Builder` is provided to encapsulate the stateful construction process of a `Tempo.Interpolation.Collection`.

You can start with an empty `Builder`,

```Swift
let builder = Tempo.Interpolation.Collection.Builder()
```

create a few interpolations (e.g., accelerando, ritardando, static),

```Swift
let a = Tempo.Interpolation(
    start: Tempo(60), 
    end: Tempo(120),
    length: Fraction(4,4)
)
let b = Tempo.Interpolation(
    start: Tempo(120), 
    end: Tempo(60),
    length: Fraction(4,4)
)
let c = Tempo.Interpolation(
    start: Tempo(60), 
    end: Tempo(60),
    length: Fraction(4,4)
)
```

then add them with the `Builder`.

```Swift
for interpolation in [a,b,c] {
    builder.add(interpoation)
}
```

Now we are ready for the `Builder` to give us a finished product.

```Swift
let collection = builder.build()
```

If it makes more sense, we can also create a `Tempo.Interpolation.Collection` directly.

```Swift
let collection = Tempo.Interpolation.Collection([a,b,c])
```

In the case that we need to retrieve a subsection of your `collection`, we can provide a subscript with a `Range<Fraction>` to get it out.

```Swift
let fragment = collection[Fraction(3,32)..<Fraction(19,8)]
```

This will produce a `Tempo.Interpolation.Collection` with three `Tempo.Interpolation.Fragments` representing the three subsections of the interpolations we created above.