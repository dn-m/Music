//
//  Model.Filter.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 6/23/17.
//
//

import struct Foundation.UUID
import Algebra
import Math

extension Model {
    
    struct Filter {
        let apply: (Model) -> Set<UUID>
    }
}

extension Model.Filter: Multiplicative {

    static var one: Model.Filter {
        return Model.Filter { model in Set(model.values.keys) }
    }

    static func * (lhs: Model.Filter, rhs: Model.Filter) -> Model.Filter {
        return Model.Filter { model in
            lhs.apply(model).intersection(rhs.apply(model))
        }
    }
}

extension Model.Filter {

    init(interval target: ClosedRange<Fraction>) {
        self.apply = { model in
            let entities = model.intervals.lazy
                .filter { _, interval in target.overlaps(interval) }
                .map { $0.0 }
            return Set(entities)
        }
    }

    init(scope: PerformanceContext.Scope) {
        self.apply = { model in
            let entities = model.performanceContexts.lazy
                .filter { _, context in scope.contains(context) }
                .map { $0.0 }
            return Set(entities)
        }
    }


    init(label: String) {
        self.apply = { model in
            return Set(model.byLabel[label] ?? [])
        }
    }
}
