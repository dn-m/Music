//
//  Dynamic+Cluster.swift
//  Dynamics
//
//  Created by James Bean on 1/3/17.
//
//

extension Dynamic {
    
    /// Structure of one or more `Dynamic` objects.
    public struct Cluster {

        fileprivate let dynamics: [Dynamic]

        public var posterior: Dynamic {
            return dynamics.first!
        }
        
        public var anterior: Dynamic {
            return dynamics.first!
        }

        public init(_ dynamics: [Dynamic]) {
            
            guard !dynamics.isEmpty else {
                fatalError("There must be 1 or more Dynamic values in a Dynamic.Cluster")
            }
            
            self.dynamics = dynamics
        }
    }
}

extension Dynamic.Cluster: Collection {
    
    // MARK: - `Collection`
    
    /// - Index after given index `i`.
    public func index(after i: Int) -> Int {
        
        guard i != endIndex else {
            fatalError("Cannot increment endIndex")
        }
        
        return i + 1
    }
    
    /// Start index.
    public var startIndex: Int {
        return 0
    }
    
    /// End index.
    public var endIndex: Int {
        return dynamics.count
    }
    
    /// - returns: Element at the given `index`.
    public subscript (index: Int) -> Dynamic {
        return dynamics[index]
    }
}
