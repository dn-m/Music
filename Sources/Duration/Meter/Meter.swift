//
//  Meter.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import DataStructures
import Math

/// Interface for `Meter`-like types (e.g., `Meter`, `AdditiveMeter`, `FractionalMeter`).
public protocol MeterProtocol {
    var beatOffsets: [Fraction] { get }
}

/// Model of a `Meter`.
public struct Meter: Rational, MeterProtocol {

    // MARK: - Instance Properties

    /// - Returns: Array of `Duration` offsets of each beat in a meter.
    public var beatOffsets: [Fraction] {
        return (0..<numerator).map { beat in Fraction(beat, denominator) }
    }

    /// Numerator.
    public let numerator: Beats

    /// Denominator.
    public let denominator: Subdivision

    // MARK: Initializers

    /// Creates a `Meter` with the given `numerator` and `denominator`.
    public init(_ numerator: Beats, _ denominator: Subdivision) {
        precondition(denominator.isPowerOfTwoWithAnyCoefficient)
        self.numerator = numerator
        self.denominator = denominator
    }
}

extension Subdivision {
    var isPowerOfTwoWithAnyCoefficient: Bool {
        if isPowerOfTwo { return true }
        return (1...self).lazy
            .filter { $0.isOdd }
            .flatMap { PowerSequence(coefficient: $0, max: self, doOvershoot: true) }
            .contains(self)
    }
}

extension Meter: Intervallic {

    public typealias Metric = Fraction

    // MARK: - DurationSpanning

    /// - Returns: The `Duration` of the `Meter`.
    public var length: Fraction {
        return Fraction(self)
    }
}

extension Meter: IntervallicFragmentable {

    // MARK: - Fragmentable

    /// - Returns: `Meter.Fragment`
    public func fragment(in range: Range<Fraction>) -> Meter.Fragment {
        return Fragment(self, in: range)
    }
}

extension Meter: ExpressibleByIntegerLiteral {

    // MARK: - ExpressibleByIntegerLiteral
    
    /// Creates a `Meter` with the given amount of `beats` at the quarter-note level.
    public init(integerLiteral beats: Int) {
        self.init(beats, 4)
    }
}

extension Meter {

    public struct Additive: MeterProtocol {
        public var beatOffsets: [Fraction] {
            fatalError()
        }
        let meters: [MeterProtocol]
        init(_ meters: MeterProtocol...) {
            self.meters = meters
        }
    }

    public struct Fractional: MeterProtocol {
        public var beatOffsets: [Fraction] {
            fatalError()
        }
        let numerator: Fraction
        let denominator: Subdivision
        public init(_ numerator: Fraction, _ denominator: Subdivision) {
            self.numerator = numerator
            self.denominator = denominator
        }
    }
}

extension Meter {

    // MARK: - Associated Types

    /// A collection of contiguous `Meter` values indexed by their fractional offset.
    public typealias Collection = ContiguousSegmentCollection<Meter>
}

/// Stateful building of a `Meter.Collection`.
public final class MeterCollectionBuilder {

    // MARK: - Associated Types
    /// The end product of this `Meter.Collection.Builder`.
    public typealias Product = Meter.Collection

    // MARK: - Instance Properties
    /// The value which will ultimately be the underlying storage of a `Meter.Collection`.
    public var intermediate: OrderedDictionary<Fraction,Meter>

    /// The accumulating offset of `Fraction` keys.
    public var offset: Fraction

    // MARK: - Initializers
    /// Create an empty `Meter.Collection.Builder` ready to help you build up a
    /// `Meter.Collection`.
    public init() {
        self.intermediate = [:]
        self.offset = .zero
    }

    /// Adds the given `element` to the `intermediate` with accumulating offsets.
    ///
    /// - Returns: `Self`.
    @discardableResult public func add(_ element: Meter) -> MeterCollectionBuilder {
        intermediate.append(element, key: offset)
        offset = offset + element.length
        return self
    }

    /// Adds each of the given `elements` to the `intermediate` with accumulating offsets.
    ///
    /// - Returns: `Self`.
    @discardableResult public func add <S: Sequence> (_ elements: S) -> Self
        where S.Element == Meter
    {
        elements.forEach { _ = add($0) }
        return self
    }

    /// Creates the final `Product` with the `intermediate`.
    public func build() -> Product {
        return Product(SortedDictionary(intermediate.map { $0 }))
    }
}
