//
//  Model.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Algebra
import DataStructures
import Math
import Duration

public typealias Attribute = Any
public typealias RhythmID = Identifier<Rhythm<[Any]>>
public typealias AttributeID = Identifier<Attribute>
public typealias EventID = Identifier<Event>

/// A single musical event, as performed by a single `Voice` in a single interval of musical time.
public struct Event {
    var isEmpty: Bool {
        return attributes.isEmpty
    }
    var attributes: [Any]
    init(_ attributes: [Any]) {
        self.attributes = attributes
    }
    func filter(_ isIncluded: (Any) -> Bool) -> Event {
        return Event(attributes.filter(isIncluded))
    }
}

extension Event: Identifiable { }

/// The database of musical information contained in a single musical _work_.
public final class Model {

    // To expand to accomodate metered / non-metered sections, as well as a concurrent meters.
    public typealias Interval = Range<Fraction>

    // MARK: - Instance Properties

    // MARK: PerformanceContext

    /// The context of performers, instruments, and voices in a work.
    let performanceContext: PerformanceContext

    // MARK: Temporal Structure

    /// The tempi contained in a work.
    let tempi: Tempo.Interpolation.Collection

    /// The meters contained in a work.
    let meters: Meter.Collection

    // MARK: Attributes

    /// Each attribute in a work, stored by a unique identifier.
    let attributeByID: [AttributeID: Attribute]

    // MARK: Events

    /// Each event in a work, stored by its interval and the identifier of the voice which performs
    /// it.
    let events: [Voice.ID: IntervalSearchTree<Fraction,Set<EventID>>]

    /// Each attribute in an event, stored by its unique identifier.
    let attributesByEvent: [EventID: Set<AttributeID>]

    // MARK: Rhythms

    /// Each rhythm in a work, stored by its interval and the identifier of the voice which performs
    /// it.
    let rhythms: [Voice.ID: IntervalSearchTree<Fraction,Set<RhythmID>>]

    /// The identifier of each event stored by the identifier of the rhythm which contains it.
    let eventsByRhythm: [RhythmID: Set<EventID>]

    // MARK: Spanners

    // TODO: Spanner (from EventID to EventID + SpannerType)

    // MARK: - Initializers

    /// Creates a `Model` with the given `performanceContext`, `tempi`, `meter`, `attributeByID`,
    /// `events`, `attributesByEvent`, `rhythms`, and `eventsByRhythm`.
    public init(
        performanceContext: PerformanceContext,
        tempi: Tempo.Interpolation.Collection,
        meters: Meter.Collection,
        attributeByID: [AttributeID: Attribute],
        events: [Voice.ID: IntervalSearchTree<Fraction,Set<EventID>>],
        attributesByEvent: [EventID: Set<AttributeID>],
        rhythms: [Voice.ID: IntervalSearchTree<Fraction,Set<RhythmID>>],
        eventsByRhythm: [RhythmID: Set<EventID>]
    )
    {
        self.performanceContext = performanceContext
        self.tempi = tempi
        self.meters = meters
        self.attributeByID = attributeByID
        self.events = events
        self.attributesByEvent = attributesByEvent
        self.rhythms = rhythms
        self.eventsByRhythm = eventsByRhythm
    }
}

extension Model: Fragmentable {

    // MARK: - Fragmentable

    /// A `Fragment` of a `Model` with the constraints of a given `Filter`.
    ///
    ///
    public struct Fragment {
        let performanceContext: PerformanceContext
        let tempoFragments: Tempo.Interpolation.Collection.Fragment
        let meterFragments: Meter.Collection.Fragment
        let attributesByID: [AttributeID: Attribute]
        let events: [Voice.ID: IntervalSearchTree<Fraction,Set<EventID>>]
        let attributesByEvent: [EventID: Set<AttributeID>]
        let rhythms: [Voice.ID: IntervalSearchTree<Fraction,Set<RhythmID>>]
        let eventsByRhythm: [RhythmID: Set<EventID>]
    }

    /// - Returns: A fragment of this `Model` with the constraints of the given `filter`.
    //
    // FIXME: This is a naive implementation, and can surely made more elegant and more efficient!
    public func fragment(filter: Filter) -> Fragment {
        let interval = filter.interval ?? .zero ..< max(tempi.length, meters.length)
        let performanceContext = self.performanceContext.filtered(by: filter.performanceContext)
        let events = Dictionary(
            self.events.lazy
                .filter { voiceID,_ in performanceContext.voiceByID.keys.contains(voiceID) }
                .map { voiceID, intervalSearchTree in (voiceID, intervalSearchTree[interval]) }
        )
        let attributesByEvent = self.attributesByEvent.filter { eventID,_ in
            return events.contains { _,intervalSearchTree in
                intervalSearchTree.base.inOrder
                    .map { $0.1.payload }
                    .contains { $0.contains(eventID) }
            }
        }
        let rhythms = Dictionary(
            self.rhythms.lazy
                .filter { voiceID,_ in performanceContext.voiceByID.keys.contains(voiceID) }
                .map { voiceID, intervalSearchTree in (voiceID, intervalSearchTree[interval]) }
        )
        let eventsByRhythm = self.eventsByRhythm.filter { rhythmID,_ in
            return rhythms.contains { _,intervalSearchTree in
                intervalSearchTree.base.inOrder
                    .map { $0.1.payload }
                    .contains { $0.contains(rhythmID) }
            }
        }
        return Fragment(
            performanceContext: performanceContext,
            tempoFragments: tempi.fragment(in: interval),
            meterFragments: meters.fragment(in: interval),
            attributesByID: attributeByID,
            events: events,
            attributesByEvent: attributesByEvent,
            rhythms: rhythms,
            eventsByRhythm: eventsByRhythm
        )
    }
}

extension Model {

    /// A `Model.Filter` splits a `Model` along three axes: interval of musical time, performing
    /// forces, and type of musical information.
    public struct Filter {

        let interval: Interval?
        let performanceContext: PerformanceContext.Filter
        let types: [Metatype]

        // MARK: - Initializers

        /// Creates a `Model.Filter` with the given `interval`, `performanceContext`, and `types`
        /// which are to be retained in a resultant `Model.Fragment`.
        init(
            interval: Interval?,
            performanceContext: PerformanceContext.Filter,
            types: [Any.Type]
        )
        {
            self.interval = interval
            self.performanceContext = performanceContext
            self.types = types.map(Metatype.init)
        }
    }
}

extension Model: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "Model"
    }
}
