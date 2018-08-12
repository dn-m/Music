# Pitch

The `Pitch` module defines basic structures for describing the "quality of a sound governed by the rate of vibrations producing it," as well as theoretical operations over them. The structures herein are agnostic to their graphical or sonic representations.

The building blocks of the `Pitch` module are the `NoteNumber`, `Frequency`, and `Pitch`.

### NoteNumber

A `NoteNumber` is a floating-point-equivalent to the `MIDI` note number message. A `NoteNumber` can be instantiated with integer and float literals:

```Swift
let middleC: NoteNumber = 60 // integer literal
let cEighthToneSharp: NoteNumber = 60.25 // float literal
```

or with a `Frequency`:

```Swift
let freq: Frequency = 440.0 // 440Hz
let a440 = NoteNumber(freq) // => NoteNumber(60)
```

### Frequency

A `Frequency` is a representation of the periodic vibration in `Herz` (cycles per second). A `Frequency` can be instantiated with integer and float literals:

```Swift
let a440: Frequency = 440 // integer literal
let middleC: Frequency = 261.6 // float literal
```

or with a `NoteNumber`:

```Swift
let nn: NoteNumber = 45
let a2 = Frequency(nn) // => Frequency(110)
```

### Pitch

A `Pitch` can be instantiated by either a `NoteNumber` or `Frequency`:

```Swift
let middleC = Pitch(noteNumber: 60)
let a440 = Pitch(frequency: 440)
```

or with integer or float literals as a `NoteNumber`:

```Swift
let fSharpAboveMiddleC: Pitch = 66.0
```

The `NoteNumber` or `Frequency` can be retrieved from a `Pitch`, like so:

```Swift
let cBelowMiddleC = Pitch(noteNumber: 48)
let freq = cBelowMiddleC.frequency // 130.81
```

Basic arithmetic operations can be performed over `Pitch` values.

```Swift
let pitch: Pitch = 72
let transpositionAmount: Pitch = 5.75
let transposedUp = pitch + transpositionAmount // => 77.75
let transposedDown = pitch - transpositionAmount // => 66.25
```

### Pitch.Class

A `Pitch.Class` is a modulo-12 view of the `NoteNumber` of a `Pitch`. This is a fundamental building block in post-tonal music-theoretical analysis, and useful for the graphical representation of pitch material.

A `Pitch.Class` can be instantiated with a `NoteNumber`:

```Swift
let anyEFlat: Pitch.Class = 3
```

The inversion of a `Pitch.Class` around `0` can be found using:

```Swift
let anyENatural: Pitch.Class = 4
let anyGSharp = anyENatural.inversion // => 8
```

### Pitch.Class.Collection

`Pitch.Class` values are often analyzed in unordered `Set` or ordered `Row` or `Sequence` collections. 

A `Pitch.Class.Collection` can be instantiated with an array literal of `Pitch.Class` values:

```Swift
let webern24: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
```

#### Set Operations

The normal and prime forms are used in post-tonal theory to find similarities between different unordered, unique pitch collections. The `normalForm` is the most compact representation of the pitch classes, while the `primeForm` is the most "left-packed" representation of the `normalForm` and the `normalForm` of the `inversion`.

```Swift
let pcs: Pitch.Class.Collection = [8,0,4,6]
let normalForm = pcs.normalForm // => [4,6,8,0]
let primeForm = pcs.primeForm // => [0,2,4,8]
```

#### Row Operations

The retrograde and inversion representations of ordered, and not-necessarily-unique collections can be found like so:

```Swift
let webern24: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
let retrograde = webern24.retrograde // => [10,2,1,6,5,9,7,8,4,3,11,0]
let inversion = webern24.inversion // => [0,1,9,8,4,5,3,7,6,11,10,2]
```