//
//  UnorderedInterval.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

import Darwin

public struct UnorderedInterval <Element: NoteNumberRepresentable>: NoteNumberRepresentable {

    public init(noteNumber: NoteNumber) {
        self.value = Element(noteNumber: noteNumber)
    }

    public var noteNumber: NoteNumber {
        return value.noteNumber
    }

    let value: Element

    init(_ a: Element, _ b: Element) {
        self.value = Element(noteNumber: NoteNumber(abs(b.noteNumber.value - a.noteNumber.value)))
    }
}
