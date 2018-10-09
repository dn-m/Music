//
//  Scale.IntervalPattern.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

import DataStructures

extension Scale {

    public struct IntervalPattern {
        let intervals: [Pitch]
    }
}

extension Scale.IntervalPattern {

    public init(_ intervals: [Pitch]) {
        self.init(intervals: intervals)
    }
}

extension Scale.IntervalPattern {
    static var major: Scale.IntervalPattern { return [2,2,1,2,2,2,1] }
    static var minor: Scale.IntervalPattern { return [2,1,2,2,1,2,2] }
    static var melodicMinorAscending: Scale.IntervalPattern { return [2,1,2,2,2,2,1] }
    static var melodicMinorDescending: Scale.IntervalPattern { return .minor }
    static var harmonicMinor: Scale.IntervalPattern { return [2,1,2,2,1,3,1] }
    static var octatonic21: Scale.IntervalPattern { return [2,1,2,1,2,1,2,1] }
    static var octatonic12: Scale.IntervalPattern { return [1,2,1,2,1,2,1,2] }
}

extension Scale.IntervalPattern: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral intervals: Pitch...) {
        self.init(intervals: intervals)
    }
}

extension Scale.IntervalPattern: CollectionWrapping {
    public var base: [Pitch] {
        return intervals
    }
}

extension Scale.IntervalPattern: Equatable { }
extension Scale.IntervalPattern: Hashable { }
