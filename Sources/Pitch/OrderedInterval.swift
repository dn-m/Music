//
//  OrderedInterval.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

public struct OrderedInterval <Element: NoteNumberRepresentable>: NoteNumberRepresentable {

    public let value: NoteNumber

    public init(_ noteNumber: NoteNumber) {
        self.value = noteNumber
    }

    init(_ a: Element, _ b: Element) {
        self.value = (b - a).value
    }
}
