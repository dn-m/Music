# Pitch

The [`Pitch`](https://github.com/dn-m/Music/tree/latest/Sources/Pitch) module provides types for structuring and transforming the frequency domain.

## Basic Types

```swift
let a440: Frequency = 440    // Hz
let middleC: Pitch = 60      // MIDI note number
let e = middleC + 4          // e above middle c
let microtone = e - 0.25     // eighth-tone below the e above middle c
let anyE = Pitch.Class(e)    // pitch class 4
let anyGSharp = anyE.inverse // pitch class 8
```

### Set Operations

```swift
let set: Pitch.Class.Collection = [8,0,4,6]
set.normalForm // => [4,6,8,0]
set.primeForm  // => [0,2,4,8]
```

### Row Transformations
```swift
let pcs: Pitch.Class.Collection = [0,11,3,4,8,7,9,5,6,1,2,10]
pcs.retrograde // => [10,2,1,6,5,9,7,8,4,3,11,0]
pcs.inversion  // => [0,1,9,8,4,5,3,7,6,11,10,2]
```

## Diatonic Intervals

```swift
let majorThird: DiatonicInterval = .M3
let minorSixth = majorThird.inverse
let AAA3 = DiatonicInterval(.triple, .augmented, .third)
let ↓majorThirteenth = CompoundDiatonicInterval(
	DiatonicInterval(.descending, .major, .sixth),
	displacedBy: 1
)
```
