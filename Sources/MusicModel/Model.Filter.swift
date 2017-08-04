//
//  Model.Filter.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 6/23/17.
//
//

import Math

extension Model {
    
    public struct Filter {
        
        let interval: ClosedRange<Fraction>?
        let scope: PerformanceContext.Scope?
        let label: String?
        
        public init(
            interval: ClosedRange<Fraction>? = nil,
            scope: PerformanceContext.Scope? = nil,
            label: String? = nil
        )
        {
            self.interval = interval
            self.scope = scope
            self.label = label
        }
    }
}
