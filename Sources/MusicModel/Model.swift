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

public typealias Event = [Any]
public typealias Attribute = Any
public typealias RhythmID = Identifier<Rhythm<Event>>
public typealias AttributeID = Identifier<Attribute>
public typealias EventID = Identifier<Event>

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
    let attributesByID: [AttributeID: Attribute]

    // MARK: Events

    /// Each event in a work, stored by its interval and the identifier of the voice which performs
    /// it.
    let events: [VoiceID: IntervalSearchTree<Fraction,Set<EventID>>]

    /// Each attribute in an event, stored by its unique identifier.
    let attributesByEvent: [EventID: Set<AttributeID>]

    // MARK: Rhythms

    /// Each rhythm in a work, stored by its interval and the identifier of the voice which performs
    /// it.
    let rhythms: [VoiceID: IntervalSearchTree<Fraction,Set<RhythmID>>]

    /// The identifier of each event stored by the identifier of the rhythm which contains it.
    let eventsByRhythm: [RhythmID: Set<EventID>]

    // MARK: Spanners

    // TODO: Spanner (from EventID to EventID + SpannerType)

    // MARK: - Initializers

    /// Creates a `Model` with the given `performanceContext`, `tempi`, `meter`, `attributesByID`,
    /// `events`, `attributesByEvent`, `rhythms`, and `eventsByRhythm`.
    public init(
        performanceContext: PerformanceContext,
        tempi: Tempo.Interpolation.Collection,
        meters: Meter.Collection,
        attributesByID: [AttributeID: Attribute],
        events: [VoiceID: IntervalSearchTree<Fraction,Set<EventID>>],
        attributesByEvent: [EventID: Set<AttributeID>],
        rhythms: [VoiceID: IntervalSearchTree<Fraction,Set<RhythmID>>],
        eventsByRhythm: [RhythmID: Set<EventID>]
    )
    {
        self.performanceContext = performanceContext
        self.tempi = tempi
        self.meters = meters
        self.attributesByID = attributesByID
        self.events = events
        self.attributesByEvent = attributesByEvent
        self.rhythms = rhythms
        self.eventsByRhythm = eventsByRhythm
    }
}

extension Model {

    /// A `Model.Filter` splits a `Model` along three axes: interval of musical time, performing
    /// forces, and type of musical information.
    public struct Filter {

        let interval: Interval?
        let performanceContext: PerformanceContext.Filter
        let types: [Any.Type]

        init(
            interval: Interval?,
            performanceContext: PerformanceContext.Filter,
            types: [Any.Type]
        )
        {
            self.interval = interval
            self.performanceContext = performanceContext
            self.types = types
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
