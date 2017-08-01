//
//  Pitch.Class.swift
//  Pitch
//
//  Created by James Bean on 7/24/17.
//  Copyright © 2017 James Bean. All rights reserved.
//

extension Pitch {

    public struct Class: NoteNumberRepresentable, PitchConvertible {

        // MARK: - Instance Properties

        /// Inversion of `Pitch.Class`.
        public var inversion: Pitch.Class {
            return Pitch.Class(12 - noteNumber.value)
        }

        /// Value of `Pitch.Class`.
        public var noteNumber: NoteNumber

        // MARK: - Initializers

        //// Create a `Pitch.Class` with a given `noteNumber`.
        public init(noteNumber: NoteNumber) {
            self.noteNumber = NoteNumber(noteNumber.value.truncatingRemainder(dividingBy: 12.0))
        }

        // MARK: - `PitchConvertible`

        /**
         Create a `Pitch.Class` with a `Pitch` object.

         **Example:**

         ```
         let pitch = Pitch(noteNumber: 65.5)
         Pitch.Class(pitch) // => 5.5
         ```
         */
        public init(_ pitch: Pitch) {
            self.init(noteNumber: pitch.noteNumber)
        }
    }
}
