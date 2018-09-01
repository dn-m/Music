//
//  Model.Builder.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 6/13/17.
//
//

import Foundation
import Algebra
import DataStructures
import Math
import Pitch
import Duration

public typealias Event = [Any]
public typealias Attribute = Any
public typealias RhythmID = Identifier<Rhythm<Event>>
public typealias AttributeID = Identifier<Attribute>
public typealias EventID = Identifier<Event>

extension Model {
    
    /// ## Creating a `Model` with a `Model.Builder`.
    ///
    /// The `AbstractMusicalModel` is a static database, containing the musical information of 
    /// a single _work_. In order to create an `AbstractMusicalModel`, we can use a `Builder`,
    /// which decouples the construction process of the model from the completed structure.
    ///
    /// First, create a `Builder`:
    ///
    ///     let builder = Model.Builder()
    ///
    /// Then, we can put things in it:
    ///
    ///     // Create a middle-c, to be played by "Pat" on the "Violin", starting on the
    ///     // second quarter-note of the piece, and will last for a single quarter-note.
    ///     let pitch = Pitch(60) // middle c
    ///     let instrument = Instrument("Violin")
    ///     let performer = Performer("Pat", [instrument])
    ///     let performanceContext = PerformanceContext(performer)
    ///     let interval = 1/>4...2/>4
    ///
    ///     // Now, we can ask the `Builder` to add it:
    ///     builder.add(pitch, label: "pitch", with: performanceContext, in: interval)
    ///
    /// Lastly, we can ask for the `AbstractMusicModel` in completed form:
    ///
    ///     let model = builder.build()
    ///
    public class Builder {

        private var attributeIdentifier: Int = 0
        private var eventIdentifier: Int = 0
        private var rhythmIdentifier: Int = 0

        var attributes: [AttributeID: Attribute] = [:]
        var events: [EventID: [AttributeID]] = [:]
        var eventsByRhythm: [RhythmID: [EventID]] = [:]
        var entitiesByInterval: [Range<Fraction>: [AttributeID]] = [:]
        var entitiesByType: [ObjectIdentifier: [AttributeID]] = [:]

        // MARK: - Builders

        let performanceContextBuilder = PerformanceContext.Builder()
        let tempoInterpolationCollectionBuilder = TempoInterpolationCollectionBuilder()
        let meterCollectionBuilder = MeterCollectionBuilder()

        // MARK: - Initializers
        
        /// Creates `Builder` prepared to construct a `Model`.
        public init() { }

        // MARK: - Performance Context

        public func addPerformer(_ performer: Performer) -> Identifier<Performer> {
            return performanceContextBuilder.addPerformer(performer)
        }

        public func addInstrument(_ instrument: Instrument) -> Identifier<Instrument> {
            return performanceContextBuilder.addInstrument(instrument)
        }

        // MARK: - Rhythm

        public func addRhythm(_ rhythm: Rhythm<[Any]>, at offset: Fraction? = nil) -> RhythmID {
            let globalOffset = offset ?? meterCollectionBuilder.offset
            let rhythmIdentifier: Identifier<Rhythm<Event>> = makeRhythmIdentifier()
            let offsetsAndDuratedEvents = zip(rhythm.eventOffsets, rhythm.duratedEvents)
            let identifiers: [EventID] = offsetsAndDuratedEvents.map { (localOffset, duratedEvent) in
                let (duration, attributes) = duratedEvent
                let localRange = Fraction(localOffset) ..< Fraction(localOffset + duration)
                let range = localRange.shifted(by: globalOffset)
                let (eventIdentifier, _) = addEvent(with: attributes, in: range)
                return eventIdentifier
            }
            eventsByRhythm[rhythmIdentifier] = identifiers
            return rhythmIdentifier
        }

        // MARK: - Tempo & Meter

        /// Add the given `tempo` at the given `offset`, and whether or not it shall be
        /// prepared to interpolate to the next given tempo.
        @discardableResult
        public func addTempo(
            _ tempo: Tempo,
            at offset: Fraction? = nil,
            easing: Tempo.Interpolation.Easing? = nil
        ) -> Builder
        {
            let offset = offset ?? meterCollectionBuilder.offset
            tempoInterpolationCollectionBuilder.add(tempo, at: offset, easing: easing)
            return self
        }

        /// Add the given `meter`.
        @discardableResult
        public func addMeter(_ meter: Meter) -> Builder {
            meterCollectionBuilder.add(meter)
            return self
        }

        // MARK: - Events and Attributes

        public func addEvent(with attributes: [Attribute], in interval: Range<Fraction>)
            -> (event: Identifier<Event>, attribute: [AttributeID])
        {
            let attributeIdentifiers = attributes.map { add($0, in: interval) }
            let eventIdentifier = createEvent(with: attributeIdentifiers, in: interval)
            return (eventIdentifier, attributeIdentifiers)
        }

        public func addEvent(with attributes: [Any]) -> (event: EventID, attributes: [AttributeID]) {
            let attributeIdentifiers = attributes.map { add($0) }
            let eventIdentifier = createEvent(with: attributeIdentifiers)
            return (eventIdentifier, attributeIdentifiers)
        }

        public func add(_ attribute: Any, in interval: Range<Fraction>) -> AttributeID {
            let identifier = makeAttributeIdentifier()
            addAttribute(attribute, withIdentifier: identifier)
            entitiesByInterval.safelyAppend(identifier, forKey: interval)
            return identifier
        }

        public func add(_ attribute: Any) -> AttributeID {
            let identifier = makeAttributeIdentifier()
            addAttribute(attribute, withIdentifier: identifier)
            return identifier
        }

        public func createEvent(with entities: [AttributeID], in interval: Range<Fraction>)
            -> EventID
        {
            let identifier = createEvent(in: interval)
            events[identifier] = entities
            entities.forEach { _ = add($0, in: interval) }
            return identifier
        }

        public func createEvent(with entities: [AttributeID]) -> EventID {
            let identifier = createEvent()
            events[identifier] = entities
            return identifier
        }

        public func createEvent(in interval: Range<Fraction>) -> EventID {
            let identifier = createEvent()
            return identifier
        }

        public func createEvent() -> EventID {
            let identifier = makeEventIdentifier()
            events[identifier] = []
            return identifier
        }

        func addAttribute(_ attribute: Any, withIdentifier identifier: Identifier<Any>) {
            attributes[identifier] = attribute
            addEntity(identifier, ofType: ObjectIdentifier(type(of: attribute)))
        }

        func addEntity(_ identifier: Identifier<Any>, ofType type: ObjectIdentifier) {
            entitiesByType.safelyAppend(identifier, forKey: type)
        }

        public func build() -> Model {
            return Model(
                performanceContext: makePerformanceContext(),
                tempi: makeTempi(),
                meters: makeMeters(),
                attributes: attributes,
                events: events,
                eventsByRhythm: eventsByRhythm,
                entitiesByInterval: entitiesByInterval,
                entitiesByType: entitiesByType
            )
        }

        private func makeTempi() -> Tempo.Interpolation.Collection {
            return tempoInterpolationCollectionBuilder.build()
        }

        private func makeMeters() -> Meter.Collection {
            return meterCollectionBuilder.build()
        }

        private func makePerformanceContext() -> PerformanceContext {
            return performanceContextBuilder.build()
        }

        private func makeEventIdentifier() -> Identifier<Event> {
            defer { eventIdentifier += 1 }
            return .init(eventIdentifier)
        }

        private func makeRhythmIdentifier <T> () -> Identifier<Rhythm<T>> {
            defer { rhythmIdentifier += 1 }
            return .init(rhythmIdentifier)
        }

        private func makeAttributeIdentifier() -> Identifier<Any> {
            defer { attributeIdentifier += 1 }
            return .init(attributeIdentifier)
        }
    }

    /// `Builder` ready to construct `Model`.
    public static var builder: Builder {
        return Builder()
    }
}
