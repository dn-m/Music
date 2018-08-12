# MetricalDuration

The `MetricalDuration` module defines basic structures for describing a symbolic representation of time through hierarchical subdivision.

The building blocks of the `MetricalDuration` module are the `Beats`, `Subdivision`, and `MetricalDuration`.

### Beats

`Beats` is merely a `typealias` for `Int`.

### Subdivision

`Subdivision` is merely a `typealias` for `Int`.

### MetricalDuration

`MetricalDuration` is a [`Rational`](https://github.com/dn-m/Math/blob/master/Sources/Math/Rational.swift) type, defined by its numerator (`Beats`) over its power-of-two denominator (`Subdivision`).

A `MetricalDuration` can be instantiated with a `Beats` and `Subdivision`:

> Warning: The denominator _must_ be a power-of-two, otherwise your program will crash.

```Swift
let dur = MetricalDuration(5,32)
let notDur = MetricalDuration(4,17) // boom
```

A `MetricalDuration` can be created with a shorthand via the operator `/>`:

```Swift
let dur = 17/>64
```