//
//  Model.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Foundation
import Algebra
import Math
import Rhythm
import Tempo
import Meter

/// The database of musical information contained in a single musical _work_.
public final class Model {
    
    /// Concrete values associated with a given unique identifier.
    public let values: [UUID: Any]
    
    /// `PerformanceContext.Path` for each entity.
    public let performanceContexts: [UUID: PerformanceContext.Path]
    
    /// Interval of each entity.
    ///
    /// - TODO: Keep sorted by interval.lowerBound
    /// - TODO: Create a richer offset type (incorporating metrical and non-metrical sections)
    ///
    public let intervals: [UUID: ClosedRange<Fraction>]
    
    /// Collection of entities for a single event (all containing same
    /// `PerformanceContext.Path` and `interval`).
    public let events: [UUID: [UUID]]
    
    /// Entities stored by their label (e.g., "rhythm", "pitch", "articulation", etc.)
    public let byLabel: [String: [UUID]]
    
    /// Rhythm events
    internal var rhythms: [Rhythm<UUID>] {
        return byLabel["rhythm"]!.map { values[$0] as! Rhythm<UUID> }
    }

    public let tempi: Tempo.Interpolation.Collection
    public let meters: Meter.Collection
    
    // MARK: - Initializers
    
    public init(
        values: [UUID: Any],
        performanceContexts: [UUID: PerformanceContext.Path],
        intervals: [UUID: ClosedRange<Fraction>],
        events: [UUID: [UUID]],
        byLabel: [String: [UUID]],
        meters: Meter.Collection,
        tempi: Tempo.Interpolation.Collection
    )
    {
        self.values = values
        self.performanceContexts = performanceContexts
        self.intervals = intervals
        self.events = events
        self.byLabel = byLabel
        self.meters = meters
        self.tempi = tempi
    }
}

extension Model: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        var result = "MODEL:\n"
        for (label, entities) in byLabel {
            result += "\(label): \(entities.map { values[$0] })\n"
        }
        for (id, event) in events {
            result += "\(id): \(event.map { values[$0] })\n"
        }
        return result
    }
}

