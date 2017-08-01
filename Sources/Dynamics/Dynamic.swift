//
//  Dynamic.swift
//  Dynamics
//
//  Created by James Bean on 4/27/16.
//
//

/**
 Structure defining a single instance of a musical dynamic (e.g., f, p, o, mp, mf, ppp).
 
 - One or more `Dynamic.Element` objects are aggregated to create a `Dynamic`.
 - One or more `Dynamic` objects are aggregated to create a `Dynamic.Cluster`.
 */
public struct Dynamic {

    // MARK: - Instance Properties

    internal let elements: [Element]
    
    // MARK: - Initializers

    /// Create a `Dynamic` with a sequence of `Dynamic.Element` values.
    public init <S: Sequence> (_ elements: S) where S.Iterator.Element == Element {
        let elements = Array(elements)
        precondition(Validator.elementsAreWellFormed(elements))
        self.elements = elements
    }
}

extension Dynamic {
    
    public var integerValue: Int {
        if elements == [.niente] {
            return Int.min
        } else if elements == [.mezzo, .forte] {
            return 1
        } else if elements == [.mezzo, .piano] {
            return -1
        } else if elements.first == .forte {
            return elements.count + 1
        } else if elements.first == .piano {
            return -1 * (elements.count + 1)
        }
        
        fatalError("Poorly formed Dynamic")
    }
}

extension Dynamic: Equatable {
    
    // MARK: - `Equatable`
    
    /// - returns: `true` if two `Dynamic` values are logically equivalent. Otherwise `false`.
    public static func == (lhs: Dynamic, rhs: Dynamic) -> Bool {
        return lhs.integerValue == rhs.integerValue
    }
}

extension Dynamic: Comparable {

    // MARK: - `Comparable`
    
    /// - returns: `true` if the left `Dynamic` value is logically less than the right.
    /// Otherwise `false`.
    public static func < (lhs: Dynamic, rhs: Dynamic) -> Bool {
        return lhs.integerValue < rhs.integerValue
    }
}

extension Dynamic: CustomStringConvertible {
    
    // MARK: - `CustomStringConvertible`
    
    /// Printable description
    public var description: String {
        return elements.reduce("") { accum, element in accum + element.rawValue }
    }
}
