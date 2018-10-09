//
//  Chord.IntervalPattern.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

extension Chord {

    // MARK: - Nested Types

    public struct IntervalPattern {
        let intervals: [Pitch]
    }
}

extension Chord.IntervalPattern {

    public init(_ intervals: [Pitch]) {
        self.init(intervals: intervals)
    }
}

extension Chord.IntervalPattern {
    static var major: Chord.IntervalPattern { return [4,3] }
    static var minor: Chord.IntervalPattern { return [3,4] }
}

extension Chord.IntervalPattern: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral intervals: Pitch...) {
        self.init(intervals: intervals)
    }
}

extension Chord.IntervalPattern: Equatable { }
extension Chord.IntervalPattern: Hashable { }
