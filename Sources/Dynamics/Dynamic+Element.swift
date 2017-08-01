//
//  Dynamic+Element.swift
//  Dynamics
//
//  Created by James Bean on 1/3/17.
//
//

extension Dynamic {
 
    /// Possible lowest-level elements that are aggregated into a `Dynamic` value.
    ///
    /// - TODO: Extend to include `"r"`,`"s"`,`"z"`,`"("`,`")"`,`"!"`,`"sub."`.
    public enum Element: String {
        
        /// Forte. Initialize with the `rawValue` `"f"`.
        case forte = "f"
        
        /// Piano. Initialize with the `rawValue` `"p"`.
        case piano = "p"
        
        /// Niente. Initialize with the `rawValue` `"o"`.
        case niente = "o"
        
        /// Mezzo. Initialize with the `rawValue` `"m"`.
        case mezzo = "m"
    }
}
