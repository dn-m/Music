# Music

![Swift Version](https://img.shields.io/badge/Swift-4.2-orange.svg)
![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)
[![Build Status](https://travis-ci.org/dn-m/Music.svg?branch=master)](https://travis-ci.org/dn-m/Music)

Structures for the creation, analysis, and performance of music in Swift.

`Music` leverages Swift's powerful generic type system to create a strongly-typed interface for describing music. A goal of the `Music` package is to encode as many of the logics of music as possible into the type system in order to enforce the validity of musical structures at compile time.

The code herein is pure Swift and has no system-specific dependencies. It supports the Linux platform, along with the Apple platforms, and will extend support to other platforms as Swift does.

## Overview

The `Music` package is part of the [**dn-m**](https://dn-m.github.io) (dynamic notation for music) project, but it's designed to be used as a standalone package for anyone wanting to write, inspect, or represent music using the Swift langage.

The structures contained herein are not concerned with (or knowledgeable of) the sonic or visual representation of music. Instead, they focus on the abstract representation of music. By means of various backend solutions, these abstract representations are interpretable as sonic or visual entities. For representing these structures graphically, look into [dn-m/NotationModel](https://github.com/dn-m/NotationModel) and [dn-m/NotationView](https://github.com/dn-m).


## API Reference

Check out the [documentation](https://dn-m.github.io) automatically generated from the source code, updated with each push to the `master` branch.

## Usage

### Installation

`Music` uses the [Swift Package Manager](https://swift.org/package-manager/) to manage its dependencies.


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

At the top of any file in which you'd like to use a module from the `Music` package, add `import` followed the name of the module:

```Swift
import Pitch
let c: Pitch = 60
let d = c + 2 // => 62
let pcs: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
let retrograde = pcs.retrograde // => [10,2,1,6,5,9,7,8,4,3,11,0]
```

```Swift
import Duration
let duration = 3/>4
let meter = Meter(15,16)
let tempo = Tempo(120,8)
```

```Swift
import Dynamics
let loud: Dynamic = .ff
let louder: Dynamic = .ffff
let lessLoud: Dynamic = .p
```

## Development


To contribute to the `Music` project, clone the `Music` package:

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
