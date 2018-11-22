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

Further, we can arrange the set into its "prime" form. A prime form is the more "left-packed" ordering of the pitch classes of the normal form of the original collection and the normal form of the inversion of the original collection. Finally, pitch classes are transposed such that the first value is the pitch class of `0`.

```Swift
let primeForm = set.primeForm
```

> `[0,2,4,8]`

### Duration

Import the `Duration` module to create and manipulate structures of musical time.

```Swift
import Duration
```

A `Duration` is a `Rational` type whose denominator must be a power-of-two.

```Swift
let crotchet = Duration(1,4)
```

> One quarter note

The infix operator `/>` can be used to construct a `Duration`.

```Swift
let dur = 3/>32
```

> Three thirty-second notes

If you attempt to create a `Duration` with a non-power-of-two denominator, your program will crash.

```Swift
let notDur = 1/>31
```

> Cannot create a 'Duration' with a non-power-of-two subdivision '31'

#### Meter

Some musics contextualize utterances within a beat structure, called a `Meter`.

```Swift
let common = Meter(4,4)
let waltz = Meter(3,4)
```

Most often, meters have a power-of-two denominator, but this is not a requirement of the type in the way that it is for `Duration`.

```Swift
let ferneyhough = Meter(13,56)
```

More complex meters can also be constructed. For example, the numerator can be represented by a fraction.

```Swift
let fractional = Meter(Fraction(3,5),16)
```

Ordinary and fractional meters can be concatenated into a single additive meter.

```Swift
let blueRondo = Meter(Meter(2,8), Meter(2,8),Meter(2,8),Meter(3,8))
let czernowinSQm5 = Meter(Meter(1,4),Meter(3,16))
let czernowinSQm7 = Meter(Meter(1,4),Meter(Fraction(2,3),4))
```

A `Meter` can be split up into a subsegment if necessary.

```Swift
let fragment = common.fragment(in: Fraction(3,32) ..< Fraction(53,64))
```

> `Meter.Fragment(Meter(4,4), in: Fraction(3,32) ..< Fraction(53,64))`

#### Meter.Collection

We can wrap these meters up into a `Meter.Collection`. `Meter.Collection` conforms to `ExpressibleByArrayLiteral`, so we can construct one without too much effort.

```Swift
let weirdMeters: Meter.Collection = [common, waltz, ferneyhough, fractional, blueRondo]
```

The `Meter.Collection` type provides affordances for splitting up a collection of meters into subsegments.

```Swift
let meters: Meter.Collection = (0..<4).map { _ in Meter(4,4) } // Four common-time meters
let fragment = meters.fragment(in: Fraction(3,4) ..< Fraction(11,4)
```

> ```
> Meter.Collection.Fragment(
>     head: Meter.Fragment(Meter(4,4), in: Fraction(3,4) ..< Fraction(4,4)),
>     body: [Meter(4,4)],
>     tail: Meter.Fragment(Meter(4,4), in: Fraction(0,4) ..< Fraction(3,4))
> )
> ```

#### Tempo

A `Tempo` is the definition of a pulse occurring at a given frequency at a given subdivision level .

```Swift
let stayinAlive = Tempo(100, subdivision: 4)
```

> 100 quarter-note beats per minute . Useful for CPR.

### Dynamics

The `Dynamic` type provides an interface to describe musical loudness in a highly subjective way.

```Swift
let loud: Dynamic = .ff
let louder: Dynamic = .ffff
let lessLoud: Dynamic = .p
```

### Articulations

The `Articulation` type provides an interface to describe the way in which a given musical entity is performed.

```Swift
let short: Articulation = .staccato
let sweet: Articulation = .tenuto
let hard: Articulation = .marcato
let hereIAm: Articulation = .accent
```

### MusicModel

The `Model` brings all of elements together from the modules contained in this package.

Use the `Model.Builder` to incrementally build up a `Model`.

```Swift
let builder = Model.Builder()
```

Constructing models of performers and instruments in your performing context.

```Swift
let performer = Performer(name: "Pat")
let instrument = Instrument(name: "Euphonium")
```

Ask `builder` to create a model of a `Voice` within its `PerformanceContext`. Retrieve the identifier for this new voice so that you can identitify musical attributes by it.

```Swift
let voiceID = builder.createVoice(performer: performer, instrument: instrument)
```

Build up a single whole note, composed of a "middle c", tenuto articulation, at the triple forte dynamic level.

```Swift
let pitch: Pitch = 60
let articulation: Articulation = .tenuto
let dynamic: Dynamic = .fff
let note = Rhythm<Event>(1/>1, [event([pitch, dynamic, articulation])])
```

Now we can ask the builder to add it to the model at the downbeat of our piece.

```Swift
let rhythmID = builder.createRhythm(note, voiceID: voiceID, offset: .zero)
```

Lastly, we can ask the builder to complete the build process, and return a shiny new `Model`.

```Swift
let model = builder.build()
```

---

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
