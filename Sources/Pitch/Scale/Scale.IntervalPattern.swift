//
//  Scale.IntervalPattern.swift
//  Pitch
//
//  Created by James Bean on 10/9/18.
//

import DataStructures

extension Scale {

    // MARK: - Nested Types

    /// The pattern of intervals which defines the quality of a `Scale`.
    ///
    /// **Example Usage**
    ///
    ///     let major: IntervalPattern = [2,2,1,2,2,2]
    ///     let wholeTone: IntervalPattern = [2,2,2,2,2,2]
    ///     let octatonic12: IntervalPattern = .octatonic12
    ///     let tetrachord = IntervalPattern([2,2,1], isLooping: false)
    ///
    public struct IntervalPattern {

        // MARK: - Instance Properties

        /// The pitch intervals comprising this `IntervalPattern`.
        let intervals: [Pitch]

        /// Whether this `IntervalPattern` protracts infinitely upward.
        let isLooping: Bool
    }
}

extension Scale.IntervalPattern {

    // MARK: - Initializers

    /// Creates a `Scale.IntervalPattern` with the given `intervals` and whether or not to
    /// protract infinitely upward.
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

    // MARK: - Type Properties

    /// Chromatic scale interval pattern.
    public static let chromatic: Scale.IntervalPattern = [1,1,1,1,1,1,1,1,1,1,1,1]

    /// Major scale interval pattern.
    public static let major: Scale.IntervalPattern = [2,2,1,2,2,2,1]

    /// Chromatic scale interval pattern.
    public static let minor: Scale.IntervalPattern = [2,1,2,2,1,2,2]

    /// Melodic minor ascending scale interval pattern.
    public static let melodicMinorAscending: Scale.IntervalPattern = [2,1,2,2,2,2,1]

    /// Melodic minor descending scale interval pattern.
    public static let melodicMinorDescending: Scale.IntervalPattern = .minor

    /// Harmonic minor scale interval pattern.
    public static let harmonicMinor: Scale.IntervalPattern = [2,1,2,2,1,3,1]

    /// Octatonic 2-1 scale interval pattern.
    public static let octatonic21: Scale.IntervalPattern = [2,1,2,1,2,1,2,1]

    /// Octatonic 1-2 scale interval pattern.
    public static let octatonic12: Scale.IntervalPattern = [1,2,1,2,1,2,1,2]

    /// Whole tone scale interval pattern.
    public static let wholeTone: Scale.IntervalPattern = [2,2,2,2,2,2]
}

extension Scale.IntervalPattern {

    // MARK: - Subscripts

    /// - Returns: A `Pitch` at the given `index`, if it exists. Otherwise, `false`.
    public subscript(index: Int) -> Pitch? {
        if intervals.indices.contains(index) || isLooping {
            return intervals[index % intervals.count]
        } else {
            return nil
        }
    }
}

extension Scale.IntervalPattern: Sequence {

    // MARK: - Sequence

    /// - Returns: An iterator for traversing the intervals in this `Scale.IntervalPattern`.
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
