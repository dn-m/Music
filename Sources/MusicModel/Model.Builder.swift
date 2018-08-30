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

        var attributes: [Identifier: Any] = [:]
        var events: [Identifier: [Identifier]] = [:]
        var eventsByRhythm: [Identifier: [Identifier]] = [:]
        var entitiesByType: [ObjectIdentifier: [Identifier]] = [:]
        var entitiesByInterval: [Range<Fraction>: [Identifier]] = [:]
        let tempoInterpolationCollectionBuilder = TempoInterpolationCollectionBuilder()
        let meterCollectionBuilder = MeterCollectionBuilder()

        // MARK: - Initializers
        
        /// Creates `Builder` prepared to construct a `Model`.
        public init() { }

        // MARK: - Rhythm

        public func addRhythm(_ rhythm: Rhythm<[Any]>, at offset: Fraction? = nil) -> Identifier {
            let globalOffset = offset ?? meterCollectionBuilder.offset
            let rhythmIdentifier = makeIdentifier()
            let offsetsAndDuratedEvents = zip(rhythm.eventOffsets, rhythm.duratedEvents)
            let identifiers: [Identifier] = offsetsAndDuratedEvents.map { (localOffset, duratedEvent) in
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
            -> (event: Identifier, attribute: [Identifier])
        {
            let attributeIdentifiers = attributes.map { add($0, in: interval) }
            let eventIdentifier = createEvent(with: attributeIdentifiers, in: interval)
            return (eventIdentifier, attributeIdentifiers)
        }

        public func addEvent(with attributes: [Any]) -> (event: Identifier, attributes: [Identifier]) {
            let attributeIdentifiers = attributes.map { add($0) }
            let eventIdentifier = createEvent(with: attributeIdentifiers)
            return (eventIdentifier, attributeIdentifiers)
        }

        public func add(_ attribute: Any, in interval: Range<Fraction>) -> Identifier {
            let identifier = makeIdentifier()
            addAttribute(attribute, withIdentifier: identifier)
            entitiesByInterval.safelyAppend(identifier, forKey: interval)
            return identifier
        }

        public func add(_ attribute: Any) -> Identifier {
            let identifier = makeIdentifier()
            addAttribute(attribute, withIdentifier: identifier)
            return identifier
        }

        public func createEvent(with entities: [Identifier], in interval: Range<Fraction>) -> Identifier {
            let identifier = createEvent(in: interval)
            events.safelyAppend(contentsOf: entities, forKey: identifier)
            return identifier
        }

        public func createEvent(with entities: [Identifier]) -> Identifier {
            let identifier = createEvent()
            events.safelyAppend(contentsOf: entities, forKey: identifier)
            return identifier
        }

        public func createEvent(in interval: Range<Fraction>) -> Identifier {
            let identifier = createEvent()
            entitiesByInterval.safelyAppend(identifier, forKey: interval)
            return identifier
        }

        public func createEvent() -> Identifier {
            let identifier = makeIdentifier()
            events[identifier] = []
            return identifier
        }

        func addAttribute(_ attribute: Any, withIdentifier identifier: Identifier) {
            attributes[identifier] = attribute
            addEntity(identifier, ofType: ObjectIdentifier(type(of: attribute)))
        }

        func addEntity(_ identifier: Identifier, ofType type: ObjectIdentifier) {
            entitiesByType.safelyAppend(identifier, forKey: type)
        }

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
