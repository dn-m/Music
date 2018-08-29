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

        public typealias Identifier = Int

        private var identifier: Int = 0

        var attributes: [UUID: Any] = [:]
        var events: [UUID: Set<UUID>] = [:]
        var eventsByRhythm: [UUID: [UUID]] = [:]
        var entitiesByType: [String: Set<UUID>] = [:]
        var entitiesByInterval: [Range<Fraction>: Set<UUID>] = [:]
        let tempoInterpolationCollectionBuilder = TempoInterpolationCollectionBuilder()
        let meterCollectionBuilder = MeterCollectionBuilder()

        // MARK: - Initializers
        
        /// Creates `Builder` prepared to construct a `Model`.
        public init() { }

        // MARK: - Rhythm

        public func addRhythm(_ rhythm: Rhythm<[Any]>, at offset: Fraction? = nil) -> UUID {
            let globalOffset = offset ?? meterCollectionBuilder.offset
            let rhythmIdentifier = UUID()
            let offsetsAndDuratedEvents = zip(rhythm.eventOffsets, rhythm.duratedEvents)
            let identifiers: [UUID] = offsetsAndDuratedEvents.map { (localOffset, duratedEvent) in
                let (duration, attributes) = duratedEvent
                let localRange = Fraction(localOffset) ..< Fraction(localOffset + duration)
                let range = localRange.shifted(by: globalOffset)
                let (eventIdentifier, _) = addEvent(with: attributes, in: range)
                return eventIdentifier
            }
            eventsByRhythm[rhythmIdentifier] = identifiers
            addAttribute(rhythm, withIdentifier: rhythmIdentifier)
            return rhythmIdentifier
        }

        // MARK: - Tempo & Meter

        /// Add the given `tempo` at the given `offset`, and whether or not it shall be
        /// prepared to interpolate to the next given tempo.
        @discardableResult public func addTempo(
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
        @discardableResult public func addMeter(_ meter: Meter) -> Builder {
            meterCollectionBuilder.add(meter)
            return self
        }

        // MARK: - Events and Attributes

        public func addEvent(with attributes: [Any], in interval: Range<Fraction>)
            -> (event: UUID, attribute: [UUID])
        {
            let attributeIdentifiers = attributes.map { add($0, in: interval) }
            let eventIdentifier = createEvent(with: Set(attributeIdentifiers), in: interval)
            return (eventIdentifier, attributeIdentifiers)
        }

        public func addEvent(with attributes: [Any]) -> (event: UUID, attributes: [UUID]) {
            let attributeIdentifiers = attributes.map { add($0) }
            let eventIdentifier = createEvent(with: Set(attributeIdentifiers))
            return (eventIdentifier, attributeIdentifiers)
        }

        public func add(_ attribute: Any, in interval: Range<Fraction>) -> UUID {
            let identifier = UUID()
            addAttribute(attribute, withIdentifier: identifier)
            entitiesByInterval.safelyInsert(identifier, forKey: interval)
            return identifier
        }

        public func add(_ attribute: Any) -> UUID {
            let identifier = UUID()
            addAttribute(attribute, withIdentifier: identifier)
            return identifier
        }

        public func createEvent(with entities: Set<UUID>, in interval: Range<Fraction>) -> UUID {
            let identifier = createEvent(in: interval)
            events.safelyFormUnion(entities, forKey: identifier)
            return identifier
        }

        public func createEvent(with entities: Set<UUID>) -> UUID {
            let identifier = createEvent()
            events.safelyFormUnion(entities, forKey: identifier)
            return identifier
        }

        public func createEvent(in interval: Range<Fraction>) -> UUID {
            let identifier = createEvent()
            entitiesByInterval.safelyInsert(identifier, forKey: interval)
            return identifier
        }

        public func createEvent() -> UUID {
            let identifier = UUID()
            events[identifier] = []
            addEntity(identifier, ofType: "EventContainer")
            return identifier
        }

        func addAttribute(_ attribute: Any, withIdentifier identifier: UUID) {
            attributes[identifier] = attribute
            addEntity(identifier, ofType: "\(type(of: attribute))")
        }

        func addEntity(_ identifier: UUID, ofType type: String) {
            entitiesByType.safelyInsert(identifier, forKey: type)
        }
        
//        /// Add the given `rhythm` at the given `offset`, zipping the given `events`, with
//        /// the given `performanceContext`.
//        ///
//        /// - TODO: Interrogate `Rhythm<Int> type`
//        /// - TODO: Refactor (need to wrap up clusters of concern)
//        ///
//        @discardableResult public func add(
//            _ rhythm: Rhythm<Int>,
//            at offset: Fraction,
//            with events: [[NamedAttribute]],
//            and performanceContext: PerformanceContext.Path = PerformanceContext.Path()
//        ) -> Builder
//        {
//            guard events.count == rhythm.leaves.count else {
//                fatalError("Incompatible rhythm and events!")
//            }
//
//            // Create UUIDs for each event in the given `rhythm`.
//            let rhythm = rhythm.map { _ in UUID() }
//
//            // Store rhythm
//            let rhythmID = createEntity(for: rhythm, label: "rhythm")
//            rhythmOffsets[rhythmID] = offset
//
//            // Store each event
//            var events = events
//            for eventEntity in rhythm.events {
//
//                // Create event
//                self.events[eventEntity] = createEntities(for: events.remove(at: 0))
//            }
//
//            return self
//        }
//
//        /// Add the named attribute values for a given `event`, performed with the
//        /// given `performanceContext`, in the given `interval`.
//        @discardableResult public func add(
//            _ event: [NamedAttribute],
//            with performanceContext: PerformanceContext.Path = PerformanceContext.Path(),
//            in interval: ClosedRange<Fraction>? = nil
//        ) -> Builder
//        {
//            let entities = event.map { namedAttribute in
//                createEntity(for: namedAttribute, with: performanceContext, in: interval)
//            }
//            createEvent(for: entities)
//            return self
//        }
//
//        /// Add the given `value` with the given `label`, performed with the given
//        /// `performanceContext`, in the given `interval`.
//        @discardableResult public func add(
//            _ value: Any,
//            label: String,
//            with performanceContext: PerformanceContext.Path = PerformanceContext.Path(),
//            in interval: ClosedRange<Fraction>? = nil
//        ) -> Builder
//        {
//            createEntity(for: value, label: label, with: performanceContext, in: interval)
//            return self
//        }
//



        public func build() -> Model {
            fatalError()
        }

        private func makeTempi() -> Tempo.Interpolation.Collection {
            return tempoInterpolationCollectionBuilder.build()
        }

        private func makeMeters() -> Meter.Collection {
            return meterCollectionBuilder.build()
        }

        private func makeIdentifier() -> Int {
            defer { identifier += 1 }
            return identifier
        }
    }

    /// `Builder` ready to construct `Model`.
    public static var builder: Builder {
        return Builder()
    }
}

/// - TODO: Move to `dn-m/Rhythm`.
extension Rhythm where Element: Equatable {
    
    var events: [Element] {
        return leaves.compactMap { leaf in
            guard case let .instance(.event(value)) = leaf else { return nil }
            return value
        }
    }
    
    // TODO: Refactor!!
    var eventIntervals: [ClosedRange<Duration>] {
        
        var result: [ClosedRange<Duration>] = []
        
        var start: Duration = 0/>4
        var current: Duration = 0/>4

        for (l, duratedLeaf) in zip(durationTree.leaves,leaves).enumerated() {
            let (duration, leaf) = duratedLeaf
            switch leaf {
            case .continuation:
                break
            case .instance(let absenceOrEvent):
                switch absenceOrEvent {
                case .absence:
                    if current > .zero {
                        result.append(start ... current)
                    }
                    start = current + duration
                case .event:
                    
                    if let previous = leaves[safe: l-1] {
                        
                        if previous != .instance(.absence) {
                            result.append(start ... current)
                        }
                    }
                    
                    start = current
                }
            }
            
            current += duration
        }
        
        if leaves.last! != .instance(.absence) {
            result.append(start ... current)
        }
        
        return result
    }
}
