//
//  Set+NoteNumberRepresentable.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

extension Collection where Iterator.Element: NoteNumberRepresentable {

    // TODO: Make lazy
    public var intervals: [OrderedInterval<Iterator.Element>] {
        return Array(self).pairs.map(OrderedInterval.init)
    }

    // TODO: Make lazy
    public var dyads: [Dyad<Iterator.Element>] {
        return Array(self).subsets(cardinality: 2).map(Dyad.init)
    }
}
