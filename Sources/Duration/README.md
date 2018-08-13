# Duration

The `Duration` module defines basic structures for describing a symbolic representation of time through hierarchical subdivision.

The building blocks of the `Duration` module are the `Duration`, `Rhythm`, `Tempo`, and `Meter`.

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

Hierarchical organization of metrical durations and their metrical contexts. The `Rhythm` structure is the composition of a `DurationTree` and an array of `Rhythm.Leaf`

### DurationTree

### Rhythm.Leaf

### Rhythm.Leaf.Kind

## Meter

## Tempo

### Tempo.Interpolation

### Tempo.Interpolation.Easing

### Tempo.Interpolation.Fragment

### Tempo.Interpolation.Collection

#### Tempo.Interpolation.Collection.Builder