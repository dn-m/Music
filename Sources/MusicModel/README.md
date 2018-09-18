# MusicModel

The `MusicModel` module defines a database for storing musical information.

## Model

The `Model` object is an aggregate of information describing the performing forces (`Performer`, `Instrument`, and `Voice`), and the musical information which is actuated by them.

### Model.Fragment

A `Model.Fragment` is the product of slicing up a `Model` with a `Model.Filter`. A `Model.Fragment` is a representation of a `Model` in a particular interval of musical time, performed by a constrained set of performing forces, within a set of desired types of musical information (e.g., `Pitch`, `Dynamics`, etc.).

### Model.Filter

A `Model.Filter` is a composition of three axes of constraint used to create a `Model.Fragment`: an interval of musical time, a set of performing forces, and a set of the types of musical information to retain.

## PerformanceContext

The `PerformanceContext` of a `Model` is an aggregation of `Performer`, `Instrument`, and `Voice` structures. In a `PerformanceContext`, there are any number of performers and instruments. A performer can play one or more instruments, and a single instrument can be played by one or more performers. 

A `Performer`-`Instrument` pair can manifest in one or more voices.

### Examples

#### Solo

The most basic example of a `PerformanceContext` is one in which there is a single `Performer`, playing through a single `Instrument`, with only a single `Voice`.

![Simple Solo](Documentation/SimpleSoloExample.png "Simple Solo")

For example, imagine a single flutist performing monophonic material.

#### Complex Solo

Often, music for a single instrument can be polyphonic, where multiple voices are performed concurrently by a performer. This can be modeled with a single `Performer` playing through a single `Instrument`, with multiple `Voice` values.

In the case of a percussion solo, for example, there is often more than one instrument played by a single `Performer`.

![Complex Solo](Documentation/ComplexSoloExample.png "Complex Solo")

In this example, a single percussionist could be playing three different instruments (e.g., snare drum, bass drum, triangle). In this case, bass drum and triangle are polyphonic. That is, there may be concurrent figures on the same instrument which are notated with different rhythmic values.

Each `Performer`-`Instrument` pair has one or more voices, each being unique to it.

#### Ensemble

Very often, people play music together. A relatively straightforward example of this is a string quartet, in which each performer's material is monophonic.

![Simple Ensemble](Documentation/SimpleEnsembleExample.png "Simple Ensemble")

#### Intertwined Ensemble

There are often cases in which multiple performers play on the same physical instrument. This happens commonly in percussion ensembles.

![Intertwined Ensemble](Documentation/IntertwinedEnsembleExample.png "Intertwined Ensemble")

In this case, imagine four percussionists, playing on two different physical instruments. Each `Performer`-`Instrument` pair emits a single, unique voice.

### PerformanceContext.Filter

A `PerformanceContext.Filter` is used to focus in on a subset of a `PerformanceContext`. It can be specified by indicating specific `Performer`, `Instrument`, or `Voice` values which are to be retained.

A `PerformanceContext.Filter` can be initialized with sets of `Performer`, `Instrument`, and/or `Voice` values.

```Swift
let filter = PerformanceContext.Filter(
    performers: [performerD], 
    instruments: [], 
    voices: [voiceB]
)
```

The default value for each parameter is an empty `Set`. If an empty set is given for a parameter, the filter will not use that parameter for constraining the `PerformanceContext`. Thus, if no parameters are given (`.init()`), no constraints are enforced by the filter, and the original `PerformanceContext` is returned in its entirety.

#### Filtering by `Performer`

When filtering a `PerformanceContext` with a set of `Performer` values, all of the voices emitted by all of the `Performer`-`Instrument` pairs including the given `Performer` values are retained.

The filter for the following example would be:

```Swift
let filter = PerformanceContext.Filter(performers: [performerB])
```

![Filter By Performer](Documentation/FilterByPerformer.png "Filter By Performer")

#### Filtering by `Instrument`

When filtering a `PerformanceContext` with a set of `Instrument` values, all of the voices emitted by all of the `Performer`-`Instrument` pairs including the given `Instrument` values are retained.

The filter for the following example would be:

```Swift
let filter = PerformanceContext.Filter(instruments: [instrument1])
```

![Filter By Instrument](Documentation/FilterByInstrument.png "Filter By Instrument")

#### Filtering by `Voice`

When filtering a `PerformanceContext` with a set of `Voice` values, all of the `Performer`-`Instrument` pairs emitting the given `Voice` values are retained.

The filter for the following example would be:

```Swift
let filter = PerformanceContext.Filter(voices: [voiceB])
```

![Filter By Voice](Documentation/FilterByVoice.png "Filter By Voice")

#### Filtering by combination

Of course, you can filter a `PerformanceContext` with a combination of `Performer`, `Instrument`, and `Voice` values. In this case, all of the applicable `Performer-Instrument` pairs and emitted voices are retained.

The filter for the following example would be:

```Swift
let filter = PerformanceContext.Filter(performers: [performerD], voices: [voiceB])
```

![Filter By Performer and Voice](Documentation/FilterByPerformerAndVoice.png "Filter By Performer And Voice")

The filter for the following example would be:

```Swift
let filter = PerformanceContext.Filter(instruments: [instrument2], voices: [voiceB])
```

![Filter By Instrument and Voice](Documentation/FilterByInstrumentAndVoice.png "Filter By Instrument And Voice")
