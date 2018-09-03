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

/// The database of musical information contained in a single musical _work_.
public final class Model {

    /// The performance context of a work.
    public var performanceContext: PerformanceContext

    /// The tempi contained in a work.
    public let tempi: Tempo.Interpolation.Collection

    /// The meters contained in a work.
    public let meters: Meter.Collection

    /// Each attribute in a work, stored by a unique identifier.
    public var attributes: [AttributeID: Attribute]

    /// Each event (composition of identifiers of attributes) in a work, stored by a unique
    /// identifier.
    public var events: [EventID: [AttributeID]]

    /// The list of identifiers of events contained in a given rhythm, as represented by a unique
    /// identifier.
    public var eventsByRhythm: [RhythmID: [EventID]]

    /// The list of identifiers of attributes stored by their fractional interval.
    public var entitiesByInterval = IntervalSearchTree<Fraction,[AttributeID]>()

    // FIXME: This is currently inefficient and does provide the desired level of type-safety.
    public var entitiesByType: [String: [AttributeID]] = [:]

    // MARK: - Initializers

    public init(
        performanceContext: PerformanceContext,
        tempi: Tempo.Interpolation.Collection,
        meters: Meter.Collection,
        attributes: [AttributeID: Attribute],
        events: [EventID: [AttributeID]],
        eventsByRhythm: [RhythmID: [EventID]],
        entitiesByInterval: IntervalSearchTree<Fraction,[AttributeID]>,
        entitiesByType: [String: [AttributeID]]
    )
    {
        self.performanceContext = performanceContext
        self.tempi = tempi
        self.meters = meters
        self.attributes = attributes
        self.events = events
        self.eventsByRhythm = eventsByRhythm
        self.entitiesByInterval = entitiesByInterval
        self.entitiesByType = entitiesByType
    }
}

extension Model: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "Model"
    }
}
