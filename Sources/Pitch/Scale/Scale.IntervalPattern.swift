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
        let isLooping: Bool
    }
}

extension Scale.IntervalPattern {

    public init(_ intervals: [Pitch], isLooping: Bool = true) {
        self.init(intervals: intervals, isLooping: isLooping)
    }
}

extension Scale.IntervalPattern {

    var span: Pitch {
        return intervals.sum
    }

    var scaleDegrees: [String] {
        switch self {
        case .major:
            return ["I","ii","iii","IV","V","vi","vii"]
        case .minor:
            return ["i","ii","III","iv","V","VI","vii"]
        default:
            return (0..<intervals.count).map { "\($0 + 1)" }
        }
    }
}

extension Scale.IntervalPattern {
    static var chromatic: Scale.IntervalPattern { return [1,1,1,1,1,1,1,1,1,1,1,1] }
    static var major: Scale.IntervalPattern { return [2,2,1,2,2,2,1] }
    static var minor: Scale.IntervalPattern { return [2,1,2,2,1,2,2] }
    static var melodicMinorAscending: Scale.IntervalPattern { return [2,1,2,2,2,2,1] }
    static var melodicMinorDescending: Scale.IntervalPattern { return .minor }
    static var harmonicMinor: Scale.IntervalPattern { return [2,1,2,2,1,3,1] }
    static var octatonic21: Scale.IntervalPattern { return [2,1,2,1,2,1,2,1] }
    static var octatonic12: Scale.IntervalPattern { return [1,2,1,2,1,2,1,2] }
}

extension Scale.IntervalPattern: Sequence {

    // MARK: - Sequence

    public subscript(index: Int) -> Pitch? {
        if intervals.indices.contains(index) || isLooping {
            return intervals[index % intervals.count]
        } else {
            return nil
        }
    }

    public func makeIterator() -> AnyIterator<Pitch> {
        var index = 0
        return AnyIterator {
            if self.intervals.indices.contains(index) || self.isLooping {
                defer { index += 1 }
                return self.intervals[index % self.intervals.count]
            } else {
                return nil
            }
        }
    }
}

extension Scale.IntervalPattern: ExpressibleByArrayLiteral {

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral intervals: Pitch...) {
        self.init(intervals: intervals, isLooping: true)
    }
}

extension Scale.IntervalPattern: Equatable { }
extension Scale.IntervalPattern: Hashable { }
