//
//  Model.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Foundation
import Algebra
import DataStructures
import Math
import Duration

/// The database of musical information contained in a single musical _work_.
public final class Model {

    public let entitiesByType: [String: [UUID]]

    /// Collection of entities for a single event (all containing same
    /// `PerformanceContext.Path` and `interval`).
    public let events: [UUID: [UUID]]

    public let tempi: Tempo.Interpolation.Collection
    public let meters: Meter.Collection
    
    // MARK: - Initializers
    
    public init(
        events: [UUID: [UUID]],
        entitiesByType: [String: [UUID]],
        meters: Meter.Collection,
        tempi: Tempo.Interpolation.Collection
    )
    {
        self.events = events
        self.entitiesByType = entitiesByType
        self.meters = meters
        self.tempi = tempi
    }
}

extension Model: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "Model"
    }
}
