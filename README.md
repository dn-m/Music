# Music

![Swift Version](https://img.shields.io/badge/Swift-4.2-orange.svg)
![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)
[![Build Status](https://travis-ci.org/dn-m/Music.svg?branch=master)](https://travis-ci.org/dn-m/Music)

Structures for the creation, analysis, and performance of music in Swift.

## Overview

The `Music` package is part of the [**dn-m**](https://dn-m.github.io) (dynamic notation for music) project, but it's designed to be used as a standalone package for anyone wanting to write, inspect, or represent music using the Swift langage.

The structures contained herein are not concerned with (or knowledgeable of) the sonic or visual representation of music. Instead, they focus on the abstract representation of music. By means of various backend solutions, these abstract representations are interpretable as sonic or visual entities. For representing these structures graphically, look into [dn-m/NotationModel](https://github.com/dn-m/NotationModel) and [dn-m/NotationView](https://github.com/dn-m).

The `Music` package leverages Swift's powerful generic type system to create a strongly-typed interface for describing music. A goal of `Music` is to encode as many of the logics of music as possible into the type system in order to enforce the validity of musical structures at compile time.

The code herein is pure Swift and has no system-specific dependencies. It supports the Linux platform, along with the Apple platforms, and will extend support to other platforms as Swift does.


## Documentation

Check out the [documentation](https://dn-m.github.io/Packages/Music) automatically generated from the source code, updated with each push to the `master` branch.

## Usage

### Pitch

Import the `Pitch` module to create and manipulate pitch-related structures.

```Swift
import Pitch
```

To start, we can create a pitch with a note number of `60` (i.e., "middle c"). `Pitch` conforms to `ExpressibleByFloatLiteral`, so you can construct a `Pitch` value without too much extra noise.

```Swift
let c: Pitch = 60
```

> Under the hood, the float literal value here (`60`) represents a `NoteNumber` instance. The `NoteNumber` structure is a floating-point analog to the MIDI integral note number concept, wherein each unit corresponds to a semitone.

Now, let's make a new pitch which is three semitones higher than our "middle c". `Pitch` conforms to `SignedNumeric`, so transposing pitches is quite elegant.

```Swift
let higher = c + 3
```

> `Pitch(63)`

And, if we want to dirty things up and make this all a little more microtonal, we needn't constrain ourselves to using integral `NoteNumber` values.

```Swift
let lessHigh = higher - 0.25
```

> `Pitch(62.75)`

If we want to do some post-tonal theoretical analysis on some given pitches, it is very helpful to convert them to `Pitch.Class` values. A pitch class is a mod-12 representation of a pitch.

```Swift
let pc = lessHigh.class
```

> `Pitch.Class(2.75)`

If we have a collection of `Pitch.Class` values, we can group them up into a `Pitch.Class.Collection`.

```Swift
let webern24: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
```

> This is the 12-tone row from Anton Webern's op. 24, *Concerto for Nine Instruments*.

There are some helpful operations that we can perform in order expose interesting similarities between different pitch collections.

```Swift
let retrograde = webern24.retrograde
```

> `[0,11,3,4,8,7,9,5,6,1,2,10]`

```Swift
let inversion = webern24.inversion 
```

> `[0,1,9,8,4,5,3,7,6,11,10,2]`

Now, consider this set of pitch classes.

```Swift
let set: Pitch.Class.Collection = [8,0,4,6]
```

We can arrange it into its "normal" form, which orders the pitch classes in their most "left-packed" arrangement (i.e., the intervals between the pitch classes are the smallest at the beginning of the collection).

```Swift
let normalForm = set.normalForm
```

> `[4,6,8,0]`

Further, we can arrange the set into its "prime" form. A prime form is the more "left-packed" ordering of the pitch classes of the normal form of the original collection and the normal form of the inversion of the original collection. Finally, this ordering is transposed such that the first value is the pitch class of `0`.

```Swift
let primeForm = self.primeForm
```

> `[0,2,4,8]`

### Duration



### Dynamics

### Articulations

### MusicModel

```Swift
import Pitch
import Duration
import Dynamics

let c: Pitch = 60 // => "middle c"
let d = c + 2 // => 62 // => Pitch(62)
let pcs: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
let retrograde = pcs.retrograde // => [10,2,1,6,5,9,7,8,4,3,11,0]

let duration = 3/>4 // => Duration(3,4) "three quarter notes"
let tempo = Tempo(120, subdivision: 8) // => "120 beats per minute at the eighth-note level"
let meter = Meter(15,16) // => "15 beats at the sixteenth-note level"
let meters: Meter.Collection = [Meter(3,4), Meter(5,16), Meter(11,28)]

let loud: Dynamic = .ff
let louder: Dynamic = .ffff
let lessLoud: Dynamic = .p
```

### Requirements

- Swift 4.2 Toolchain
- [Swift Package Manager](https://swift.org/package-manager/)

### Installation




In order to use the `Music` API, add it to the `dependencies` section of your `Package.swift` file:

```Swift
let package = Package(
    name: ...,
    products: [ ... ],
    dependencies: [
        ...,
        .package(url: "https://github.com/dn-m/Music", from: "0.7.0")
    ],
    targets: [ ... ]
)
```


## Development


To contribute to the `Music` package, clone the `git` repository:

```
git clone https://github.com/dn-m/Music && cd Music
```

Build the package:

```
swift build
```

Run the tests:

```
swift test
```

If you use the Xcode IDE, use SwiftPM to generate an `.xcodeproj` file:

```
swift package generate-xcodeproj
```

### Architecture

`Music` is split up into several modules:

- [`Pitch`](https://github.com/dn-m/Music/tree/master/Sources/Pitch)
- [`Duration`](https://github.com/dn-m/Music/tree/master/Sources/Duration)
- [`Dynamics`](https://github.com/dn-m/Music/tree/master/Sources/Dynamics)
- [`Articulations`](https://github.com/dn-m/Music/tree/master/Sources/Articulations)
- [`MusicModel`](https://github.com/dn-m/Music/tree/master/Sources/MusicModel)

## Inspiration

Here are some libraries in other languages that have been influential to the design of the `Music` package:

- [Abjad](http://abjad.mbrsi.org) (Python)
- [Music21](http://web.mit.edu/music21/) (Python)
- [Haskore](https://wiki.haskell.org/Haskore) (Haskell)
- [Mezzo](http://hackage.haskell.org/package/mezzo) (Haskell)
- [GUIDO](http://science.jkilian.de/salieri/GUIDO/index.html) (C++)
