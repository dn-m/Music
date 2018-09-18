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

extension Model {

    public class Builder {

        // MARK: - Private State

        private var attributeIdentifier: Int = 0
        private var eventIdentifier: Int = 0
        private var rhythmIdentifier: Int = 0

        // MARK: - Instance Properties

        // MARK: Attributes

        /// Each attribute in a work, stored by a unique identifier.
        var attributeByID: [AttributeID: Attribute] = [:]

        // MARK: Events

        /// Each event in a work, stored by its interval and the identifier of the voice which performs
        /// it.
        var events: [Voice.ID: IntervalSearchTree<Fraction,Set<EventID>>] = [:]

        /// Each attribute in an event, stored by its unique identifier.
        var attributesByEvent: [EventID: Set<AttributeID>] = [:]

        // MARK: Rhythms

        /// Each rhythm in a work, stored by its interval and the identifier of the voice which performs
        /// it.
        var rhythms: [Voice.ID: IntervalSearchTree<Fraction,Set<RhythmID>>] = [:]

        /// The identifier of each event stored by the identifier of the rhythm which contains it.
        var eventsByRhythm: [RhythmID: Set<EventID>] = [:]

        // TODO: Spanner (from EventID to EventID + SpannerType)

        // MARK: - Builders

        let performanceContextBuilder = PerformanceContext.Builder()
        let tempoInterpolationCollectionBuilder = TempoInterpolationCollectionBuilder()
        let meterCollectionBuilder = MeterCollectionBuilder()

        // MARK: - Initializers
        
        /// Creates `Builder` prepared to construct a `Model`.
        public init() { }

        // MARK: - Rhythm

        /// Creates an entry for the given `rhythm`, performed by the given `voiceID`, at the give
        /// `offset`.
        public func createRhythm(_ rhythm: Rhythm<Event>, voiceID: Voice.ID, offset: Fraction)
            -> RhythmID
        {
            let rhythmID = makeRhythmIdentifier()
            let offsetsAndDuratedEvents = zip(rhythm.eventOffsets, rhythm.duratedEvents)
            let eventIDs: Set<EventID> = Set(
                offsetsAndDuratedEvents.lazy.map { [unowned self] (localOffset, duratedEvent) in
                    let (duration, event) = duratedEvent
                    let localInterval = Fraction(localOffset) ..< Fraction(localOffset + duration)
                    let interval = localInterval.shifted(by: offset)
                    return self.createEvent(
                        attributes: event.attributes,
                        voiceID: voiceID,
                        interval: interval
                    )
                }
            )
            storeEventIDs(eventIDs, by: rhythmID)
            let interval = offset ..< offset + Fraction(rhythm.durationTree.duration)
            storeRhythm(id: rhythmID, voiceID: voiceID, interval: interval)
            return rhythmID
        }

        private func storeRhythm(id rhythm: RhythmID, voiceID: Voice.ID, interval: Model.Interval) {
            rhythms[voiceID, default: .empty].insert(.init(interval: interval, value: [rhythm]))
        }

        private func storeEventIDs(_ ids: Set<EventID>, by rhythmID: RhythmID) {
            eventsByRhythm[rhythmID] = ids
        }

        /// Creates an event with the given `attributes`, performed by the given `voiceID`, in the
        /// given `interval`.
        ///
        /// - Returns: An `EventID` for the new event.
        public func createEvent(
            attributes: [Any],
            voiceID: Voice.ID,
            interval: Model.Interval
        ) -> EventID
        {
            let eventID = makeEventIdentifier()
            let attributeIDs = attributes.map { _ in self.makeAttributeIdentifier() }
            storeAttributes(attributes, withIDs: attributeIDs)
            storeAttributeIDs(Set(attributeIDs), by: eventID)
            storeEvent(id: eventID, voiceID: voiceID, interval: interval)
            return eventID
        }

        private func storeEvent(id event: EventID, voiceID: Voice.ID, interval: Model.Interval) {
            events[voiceID, default: .empty].insert(.init(interval: interval, value: [event]))
        }

        private func storeAttributeIDs(_ ids: Set<AttributeID>, by eventID: EventID) {
            attributesByEvent[eventID] = ids
        }

        private func storeAttributes(_ attributes: [Any], withIDs ids: [AttributeID]) {
            zip(ids,attributes).forEach { id, attribute in attributeByID[id] = attribute }
        }

        private func makePerformanceContext() -> PerformanceContext {
            return performanceContextBuilder.build()
        }

        private func makeAttributeIdentifier() -> AttributeID {
            defer { attributeIdentifier += 1 }
            return .init(attributeIdentifier)
        }

        private func makeEventIdentifier() -> EventID {
            defer { eventIdentifier += 1 }
            return .init(eventIdentifier)
        }

        private func makeRhythmIdentifier() -> RhythmID {
            defer { rhythmIdentifier += 1 }
            return .init(rhythmIdentifier)
        }
    }
}

extension Model.Builder {

    // MARK: - Performance Context

    /// Adds the given `performer` to the performance context.
    public func createPerformer(_ performer: Performer) -> Performer.ID {
        return performanceContextBuilder.addPerformer(performer)
    }

    /// Adds the given `instrument` to the performance context.
    public func createInstrument(_ instrument: Instrument) -> Instrument.ID {
        return performanceContextBuilder.addInstrument(instrument)
    }

    /// Adds the given voice identifier for the given `performer` and `instrument`.
    public func createVoice(_ voice: Voice? = nil, performer: Performer, instrument: Instrument)
        -> Voice.ID
    {
        return performanceContextBuilder.addVoice(voice,
            performer: performer,
            instrument: instrument
        )
    }
}

extension Model.Builder {

    // MARK: - Tempo & Meter

    /// Add the given `tempo` at the given `offset`, and whether or not it shall be
    /// prepared to interpolate to the next given tempo.
    @discardableResult
    public func addTempo(
        _ tempo: Tempo,
        at offset: Fraction? = nil,
        easing: Tempo.Interpolation.Easing? = nil
    ) -> Model.Builder
    {
        let offset = offset ?? meterCollectionBuilder.offset
        tempoInterpolationCollectionBuilder.add(tempo, at: offset, easing: easing)
        return self
    }

    /// Add the given `meter`.
    @discardableResult
    public func addMeter(_ meter: Meter) -> Model.Builder {
        meterCollectionBuilder.add(meter)
        return self
    }
}

extension Model.Builder {

    // MARK: - Build

    /// - Returns: A completed `Model` for your enjoyment.
    public func build() -> Model {
        return Model(
            performanceContext: makePerformanceContext(),
            tempi: makeTempi(),
            meters: makeMeters(),
            attributeByID: attributeByID,
            events: events,
            attributesByEvent: attributesByEvent,
            rhythms: rhythms,
            eventsByRhythm: eventsByRhythm
        )
    }

    private func makeTempi() -> Tempo.Interpolation.Collection {
        return tempoInterpolationCollectionBuilder.build()
    }

    private func makeMeters() -> Meter.Collection {
        return meterCollectionBuilder.build()
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
