//
//  Dynamic+Interpolation.swift
//  Dynamics
//
//  Created by James Bean on 4/27/16.
//
//

extension Dynamic {
    
    public struct Interpolation: Equatable {
        
        public enum Direction {
            case crescendo
            case decrescendo
            case none
        }
        
        public let direction: Direction
        
        init(direction: Direction) {
            self.direction = direction
        }
    }
}
