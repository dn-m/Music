# Music

![Swift Version](https://img.shields.io/badge/Swift-5.x-orange.svg)
![Platforms](https://img.shields.io/badge/platform-linux%20%7C%20macOS%20%7C%20iOS%20%7C%20watchOS%20%7C%20tvOS-lightgrey.svg)
[![Build Status](https://travis-ci.org/dn-m/Music.svg?branch=latest)](https://travis-ci.org/dn-m/Music)

Structures for the creation, analysis, and performance of music in Swift. Check out the [documentation](https://dn-m.github.io/Packages/Music).

## Overview

`Music` is a package for anyone who wants to create, analyze, and perform music in pure Swift.

## Usage

### 🎶 Pitch

The [`Pitch`](https://github.com/dn-m/Music/tree/latest/Sources/Pitch) module provides types for structuring and transforming the frequency domain.

#### Basic Types

```swift
let a440: Frequency = 440    // Hz
let middleC: Pitch = 60      // MIDI note number
let e = middleC + 4          // e above middle c
let microtone = e - 0.25     // eighth-tone below the e above middle c
let anyE = Pitch.Class(e)    // pitch class 4
let anyGSharp = anyE.inverse // pitch class 8
```

#### Set Operations

```swift
let set: Pitch.Class.Collection = [8,0,4,6]
set.normalForm // => [4,6,8,0]
set.primeForm  // => [0,2,4,8]
```

#### Row Transformations
```swift
let pcs: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
pcs.retrograde // => [10,2,1,6,5,9,7,8,4,3,11,0]
pcs.inversion  // => [0,1,9,8,4,5,3,7,6,11,10,2]
```

#### Diatonic Intervals

```swift
let majorThird: DiatonicInterval = .M3
let minorSixth = majorThird.inverse
let AAA3 = DiatonicInterval(.triple, .augmented, .third)
let noSuchThing = DiatonicInterval(.major, .fifth) ❌ will not compile!
```

---

### ♬ Duration

The [`Duration`](https://github.com/dn-m/Music/tree/latest/Sources/Duration) module provides types for structuring and transforming the time domain.

#### Basic Types

```swift
let crotchet = Duration(1,4)
let waltz = Meter(3,4)
let stayinAlive = Tempo(100, subdivision: 4)
```

---

### 🎚️ Dynamics

The `Dynamic` module provides ways to describe musical loudness in a highly subjective way.

```Swift
let loud: Dynamic = .ff
let quiet: Dynamic = .p
let interp = Dynamic.Interpolation(from: .p, to: .ff)
```

---

### 🥁 Articulations

The `Articulation` type provides an interface to describe the way in which a given musical entity is performed.

```Swift
let short: Articulation = .staccato
let sweet: Articulation = .tenuto
let hard: Articulation = .marcato
let hereIAm: Articulation = .accent
```

---

### 💾 MusicModel

The `Model` brings all of elements together from the modules contained in this package.

```Swift
let builder = Model.Builder()
let performer = Performer(name: "Pat")
let instrument = Instrument(name: "Euphonium")
let voiceID = builder.createVoice(performer: performer, instrument: instrument)
let pitch: Pitch = 60
let articulation: Articulation = .tenuto
let dynamic: Dynamic = .fff
let note = Rhythm<Event>(1/>1, [event([pitch, dynamic, articulation])])
let rhythmID = builder.createRhythm(note, voiceID: voiceID, offset: .zero)
let model = builder.build()
```

---

## Requirements

In order to use the `Music` package, you'll need a few things:

- Swift 5.x Toolchain (Xcode 10.2–11, or [here](https://swift.org/download/))
- [Swift Package Manager](https://swift.org/package-manager/)

## Installation

In order to use the `Music` modules in your own projects, add it to the `dependencies` section of your `Package.swift` file:

```Swift
let package = Package(
    name: ...,
    products: [ ... ],
    dependencies: [
        ...,
        .package(url: "https://github.com/dn-m/Music", from: "0.17.1")
    ],
    targets: [ ... ]
)
```

## Development


To contribute to the `Music` package, clone the `git` repository:

```
git clone https://github.com/dn-m/Music && cd Music
```

If you use the Xcode IDE on macOS, you can use SwiftPM to generate an `.xcodeproj` file:

```
swift package generate-xcodeproj
```

## Inspiration

Here are some libraries in other languages that have been influential to the design of the `Music` package:

- [Abjad](http://abjad.mbrsi.org) (Python)
- [Music21](http://web.mit.edu/music21/) (Python)
- [Haskore](https://wiki.haskell.org/Haskore) (Haskell)
- [Mezzo](http://hackage.haskell.org/package/mezzo) (Haskell)
- [GUIDO](http://science.jkilian.de/salieri/GUIDO/index.html) (C++)
