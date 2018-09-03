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
            let attributeIdentifiers = attributes.map { add($0) }
            let eventIdentifier = createEvent(with: attributeIdentifiers, in: interval)
            let istNode = ISTNode(interval: interval, value: attributeIdentifiers)
            entitiesByInterval.insert(istNode, forKey: interval.lowerBound)
            return (eventIdentifier, attributeIdentifiers)
        }

        public func addEvent(with attributes: [Any]) -> (event: EventID, attributes: [AttributeID]) {
            let attributeIdentifiers = attributes.map { add($0) }
            let eventIdentifier = createEvent(with: attributeIdentifiers)
            return (eventIdentifier, attributeIdentifiers)
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
            //entities.forEach { _ = add($0, in: interval) }
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
            addEntity(identifier, ofType: "\(type(of: attribute))")
        }

        func addEntity(_ identifier: Identifier<Any>, ofType type: String) {
            entitiesByType[type, default: []].append(identifier)
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

enum AttributionError: Swift.Error {
    case leafIndexOutOfBounds(Int)
    case nonEventLeafToAddAttribute(Any)
}

extension Rhythm where Element: RangeReplaceableCollection, Element.Element == Any {

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
