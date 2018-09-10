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
    var performanceContext: PerformanceContext

    /// The tempi contained in a work.
    let tempi: Tempo.Interpolation.Collection

    /// The meters contained in a work.
    let meters: Meter.Collection

    /// Each attribute in a work, stored by a unique identifier.
    var attributes: [AttributeID: Attribute]

    /// Each event (composition of identifiers of attributes) in a work, stored by a unique
    /// identifier.
    var events: [EventID: [AttributeID]]

    /// The list of identifiers of events contained in a given rhythm, as represented by a unique
    /// identifier.
    var eventsByRhythm: [RhythmID: [EventID]]

    /// The list of identifiers of attributes stored by their fractional interval.
    var entitiesByInterval = IntervalSearchTree<Fraction,[AttributeID]>()

    var entitiesByType: [Metatype: [AttributeID]] = [:]

    var attributesByVoice: [VoiceID: [AttributeID]] = [:]

    // MARK: - Initializers

    public init(
        performanceContext: PerformanceContext,
        tempi: Tempo.Interpolation.Collection,
        meters: Meter.Collection,
        attributes: [AttributeID: Attribute],
        events: [EventID: [AttributeID]],
        eventsByRhythm: [RhythmID: [EventID]],
        entitiesByInterval: IntervalSearchTree<Fraction,[AttributeID]>,
        attributesByVoice: [VoiceID: [AttributeID]],
        entitiesByType: [Metatype: [AttributeID]]
    )
    {
        self.performanceContext = performanceContext
        self.tempi = tempi
        self.meters = meters
        self.attributes = attributes
        self.events = events
        self.eventsByRhythm = eventsByRhythm
        self.entitiesByInterval = entitiesByInterval
        self.attributesByVoice = attributesByVoice
        self.entitiesByType = entitiesByType
    }

    /// - Returns: The identifiers for attributes in the given `interval`.
    public func attributes(in interval: Range<Fraction>) -> [AttributeID] {
        return entitiesByInterval.intervals(overlapping: interval).flatMap { $0.payload }
    }

    /// - Returns: The identifiers for attributes performed by the given voice.
    public func attributes(by voice: VoiceID) -> [AttributeID] {
        return attributesByVoice[voice] ?? []
    }

    /// - Returns: The identifiers for attributes with the given `type`.
    public func attributes(type: Any.Type) -> [AttributeID] {
        return entitiesByType[Metatype(type)] ?? []
    }
}

extension Model: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "Model"
    }
}
