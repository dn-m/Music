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

    public var performanceContext: PerformanceContext
    public let tempi: Tempo.Interpolation.Collection
    public let meters: Meter.Collection
    public var attributes: [AttributeID: Attribute]
    public var events: [EventID: [AttributeID]]
    public var eventsByRhythm: [RhythmID: [EventID]]
    public var entitiesByInterval = IntervalSearchTree<Fraction,[AttributeID]>()
    public var entitiesByType: [String: [AttributeID]] = [:]

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
