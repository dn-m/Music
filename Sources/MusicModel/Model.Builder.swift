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

// FIXME: Move to dn-m/Structure/Algebra/AlgebraAdapters
extension Array: Additive {
    public static var zero: Array {
        return []
    }
}

extension Model {

    public class Builder {

        private var attributeIdentifier: Int = 0
        private var eventIdentifier: Int = 0
        private var rhythmIdentifier: Int = 0

        /// All attributes stored by their unique identifier.
        ///
        /// The attributes here are the raw values of the musical model (`Pitch`, `Dynamic`, etc.)
        var attributes: [AttributeID: Attribute] = [:]

        /// All of the identifiers of attributes stored by the `ObjectIdentifier` representing
        /// their type.
        ///
        // FIXME: There must be a more efficient way to store entities in a way wherein the type
        // can be reified. The `String` init is not efficient, and doesn't really carry with it
        // its own type information.
        var entitiesByType: [String: [AttributeID]] = [:]

        /// All of the identifiers of the attributes contained in a single event.
        var events: [EventID: [AttributeID]] = [:]

        /// All of the identifiers of the events contained in a single rhythm.
        var eventsByRhythm: [RhythmID: [EventID]] = [:]

        /// An `IntervalSearchTree` with all of the identifiers of the attributes occurring in a
        /// a given `Fraction` interval.
        var entitiesByInterval = IntervalSearchTree<Fraction,[AttributeID]>()

        /// All of the identifiers of the attributes performed by a given `PerformerInstrumentPair`.
        var entitiesByPerformerInstrumentPair: [PerformerInstrumentPair: [VoiceID]] = [:]

        // MARK: - Builders

        let performanceContextBuilder = PerformanceContext.Builder()
        let tempoInterpolationCollectionBuilder = TempoInterpolationCollectionBuilder()
        let meterCollectionBuilder = MeterCollectionBuilder()

        // MARK: - Initializers
        
        /// Creates `Builder` prepared to construct a `Model`.
        public init() { }

        // MARK: - Performance Context

        /// Adds the given `performer` to the performance context.
        public func addPerformer(_ performer: Performer) -> PerformerID {
            return performanceContextBuilder.addPerformer(performer)
        }

        /// Adds the given `instrument` to the performance context.
        public func addInstrument(_ instrument: Instrument) -> InstrumentID {
            return performanceContextBuilder.addInstrument(instrument)
        }

        public func addVoice(
            _ voice: Int? = nil,
            forPerformer performer: Performer,
            forInstrument instrument: Instrument
        ) -> VoiceID
        {
            return performanceContextBuilder.addVoice(
                forPerformer: performer,
                withInstrument: instrument,
                number: voice
            )
        }

        // MARK: - Rhythm

        /// Adds the given `rhythm` at the given `offset`, if it exists. If no `offset` is given,
        /// the `rhythm` will be added at the current offset of the current meter.
        public func addRhythm(
            _ rhythm: Rhythm<[Any]>,
            at offset: Fraction? = nil,
            performedOn instrument: Instrument,
            by performer: Performer,
            voice: Int? = nil
        ) -> RhythmID
        {
            let performerID = addPerformer(performer)
            let instrumentID = addInstrument(instrument)
            let voiceID = addVoice(voice, forPerformer: performer, forInstrument: instrument)
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

        /// Adds an event with the given `attributes` in the given `interval`.
        ///
        /// - Returns: The identifiers for the event and the attributes.
        public func addEvent(with attributes: [Attribute], in interval: Range<Fraction>)
            -> (event: EventID, attributes: [AttributeID])
        {
            let attributeIdentifiers = attributes.map { add($0) }
            let eventIdentifier = createEvent(with: attributeIdentifiers, in: interval)
            let istNode = ISTNode(interval: interval, value: attributeIdentifiers)
            entitiesByInterval.insert(istNode, forKey: interval.lowerBound)
            return (eventIdentifier, attributeIdentifiers)
        }

        /// Adds an event with the given `attributes`.
        ///
        /// - Returns: The identifiers for the event and the attributes.
        public func addEvent(with attributes: [Any]) -> (event: EventID, attributes: [AttributeID]) {
            let attributeIdentifiers = attributes.map { add($0) }
            let eventIdentifier = createEvent(with: attributeIdentifiers)
            return (eventIdentifier, attributeIdentifiers)
        }

        /// Adds the given `attribute`.
        ///
        //// - Returns: The identifier for the attribute.
        public func add(_ attribute: Any) -> AttributeID {
            let identifier = makeAttributeIdentifier()
            addAttribute(attribute, withIdentifier: identifier)
            return identifier
        }

        /// Creates an event with the given `attributes` in the given `interval`.
        ///
        /// - Returns: The identifier for the event.
        public func createEvent(with attributes: [AttributeID], in interval: Range<Fraction>)
            -> EventID
        {
            let identifier = createEvent(in: interval)
            events[identifier] = attributes
            return identifier
        }

        /// Creates an event with the given `attributes`.
        ///
        /// - Returns: The identifier for the event.
        public func createEvent(with attributes: [AttributeID]) -> EventID {
            let identifier = createEvent()
            events[identifier] = attributes
            return identifier
        }

        /// Creates and event in the given `interval`.
        ///
        //// - Returns: The identifier for the event.
        public func createEvent(in interval: Range<Fraction>) -> EventID {
            let identifier = createEvent()
            return identifier
        }

        /// Creates an event.
        ///
        /// - Returns: The identifier for the event.
        public func createEvent() -> EventID {
            let identifier = makeEventIdentifier()
            events[identifier] = []
            return identifier
        }

        /// Adds the given `attribute` with the given `identifier`.
        func addAttribute(_ attribute: Any, withIdentifier identifier: AttributeID) {
            attributes[identifier] = attribute
            addEntity(identifier, ofType: "\(type(of: attribute))")
        }

        /// Adds an entity with the given `identifier` with the given string representaiton of
        /// its `type`.
        func addEntity(_ identifier: AttributeID, ofType type: String) {
            entitiesByType[type, default: []].append(identifier)
        }

        /// - Returns: A completed `Model` for your enjoyment.
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

        private func makeEventIdentifier() -> EventID {
            defer { eventIdentifier += 1 }
            return .init(eventIdentifier)
        }

        private func makeRhythmIdentifier <T> () -> Identifier<Rhythm<T>> {
            defer { rhythmIdentifier += 1 }
            return .init(rhythmIdentifier)
        }

        private func makeAttributeIdentifier() -> AttributeID {
            defer { attributeIdentifier += 1 }
            return .init(attributeIdentifier)
        }
    }

    /// `Builder` ready to construct `Model`.
    public static var builder: Builder {
        return Builder()
    }
}

enum AttributionError: Swift.Error {
    case leafIndexOutOfBounds(Int)
    case nonEventLeafToAddAttribute(Any)
}

extension Rhythm where Element: RangeReplaceableCollection, Element.Element == Any {

    /// Add the given `attribute` at the given `index` of leaves.
    ///
    /// If the leaf is a tie or rest, an event is injected with the given `attribute`. Otherwise,
    /// the `attribute` is added to the extant list of attributes.
    mutating func add(_ attribute: Any, at index: Int) {
        switch leaves[index].context {
        case .continuation:
            var attributes = Element()
            attributes.append(attribute)
            leaves[index].context = event(attributes)
        case .instance(let absenceOrEvent):
            switch absenceOrEvent {
            case .absence:
                var attributes = Element()
                attributes.append(attribute)
                leaves[index].context = event(attributes)
            case .event(var attributes):
                attributes.append(attribute)
                leaves[index].context = event(attributes)
            }
        }
    }
}
