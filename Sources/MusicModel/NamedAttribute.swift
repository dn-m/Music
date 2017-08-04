//
//  NamedAttribute.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 6/23/17.
//
//

public struct NamedAttribute {
    
    public let name: String
    public let attribute: Any
    
    public init(_ attribute: Any, name: String) {
        self.attribute = attribute
        self.name = name
    }
}
