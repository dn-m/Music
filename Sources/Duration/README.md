# Duration

The `Duration` module defines basic structures for describing a symbolic representation of time by hierarchical subdivision. The building blocks of the `Duration` module are the `Duration`, `Rhythm`, `Tempo`, and `Meter` structures.

## Duration

The `Duration` structure is a [`Rational`](https://github.com/dn-m/Math/blob/master/Sources/Math/Rational.swift) type, defined by its numerator (`Beats`) over its power-of-two denominator (`Subdivision`).

A `Duration` can be instantiated with a `Beats` and `Subdivision`:

```Swift
let dur = Duration(5,32)
```

> Warning: The denominator _must_ be a power-of-two, otherwise your program will crash.

```Swift
let notDur = Duration(4,17) // boom
```

A `Duration` can be created with a shorthand via the operator `/>`:

```Swift
let dur = 17/>64
```

## Rhythm

A `Rhythm` is a hierarchical organization of metrical durations with their metrical contexts for the purpose of defining arbitrarily-nested tuplet values. The `Rhythm` structure is the composition of a `DurationTree` and an array of `Rhythm.Leaf` values.

### DurationTree

A `DurationTree` is a `typealias` for `Tree<Duration,Duration>`, from the [`dn-m/Structure/DataStructures`](https://dn-m.github.io/Packages/Structure/Modules/DataStructures/index.html) module.

### Rhythm.Leaf

A `Rhythm.Leaf` models the metrical identity of a given rhythmic leaf item. It is a `typealias` for `ContinuationOrInstance<AbsenceOrEvent<Element>>`.

 - "tied": if a leaf is "tied" over from the previous event (`.contiuation`)
 - "rest": if a leaf is a "rest", a measured silence (`.instance(.rest)`)
 - "event": if a leaf is a measured non-silence (`.instance(.event(Element))`)

#### ContinuationOrInstance<Element>

Whether a rhythmic item is "tied-over" from its preceeding item (`.continuation`), or if it a "rest" or a "note" (`.instance(Element)`).

#### AbsenceOrEvent<Element>

Whether a rhythmic item is a "rest" (`.absence`) or a "note" (`.event(Element)`).

## Meter

Like a `Duration`, a `Meter` is a `Rational` type, used for defining the metrical context of measure.

## Tempo

A `Tempo` is the definition of a pulse occurring at a given frequency (`beatsPerMinute`) at a given `Subdivision` level (e.g., quarter, sixteenth, etc.).

### Tempo.Interpolation

A `Tempo.Interpolation` defines a transition between two `Tempo` values, over a given `length`, with a specified `easing`.

### Tempo.Interpolation.Easing

A `Tempo.Interpolation.Easing` specifies the curve of a `Tempo.Interpolation`. 

- `linear`
- `powerIn`
- `powerInOut`
- `exponentialIn`
- `sineInOut`

### Tempo.Interpolation.Fragment

A `Tempo.Interpolation.Fragment` is a portion of a `Tempo.Interpolation` within a given `range`.

### Tempo.Interpolation.Collection

A `Tempo.Interpolation.Collection` defines a contiguous collection of `Tempo.Interpolation.Fragment` values, which are indexed by the offset `Fraction` value.
