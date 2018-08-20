//
//  TuningSystem.swift
//  Pitch
//
//  Created by James Bean on 8/19/18.
//

/// Interface for tuning systems.
public protocol TuningSystem { }

public protocol EDO: TuningSystem {
    static var divisions: Int { get }
    static func frequency(_ noteNumber: NoteNumber) -> Frequency
    static func noteNumber(_ frequency: Frequency) -> NoteNumber
}

/// Cents
enum EDO1200 { }

enum EDOMAX { }

public enum EDO12: EDO {
    public static var divisions: Int { return 12 }
    public static func frequency(_ noteNumber: NoteNumber) -> Frequency {
        return 0
    }

    public static func noteNumber(_ frequency: Frequency) -> NoteNumber {
        return 0
    }
}

public enum EDO24: EDO {
    public static var divisions: Int { return 24 }
    public static func frequency(_ noteNumber: NoteNumber) -> Frequency {
        return 0
    }

    public static func noteNumber(_ frequency: Frequency) -> NoteNumber {
        return 0
    }
}

public enum EDO48: EDO {
    public static var divisions: Int { return 48 }
    public static func frequency(_ noteNumber: NoteNumber) -> Frequency {
        return 0
    }

    public static func noteNumber(_ frequency: Frequency) -> NoteNumber {
        return 0
    }
}
