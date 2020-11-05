//
//  PropertyStreamBehavior.swift
//
//
//  Created by Hugh Bellamy on 05/11/2020.
//

/// [MS-OLEPS] 2.18.4 Behavior Property
/// The Behavior property, if present, MUST have the property identifier 0x80000003, MUST NOT have a property name, and
/// MUST have type VT_UI4 (0x0013). A version 0 property set, indicated by the value 0x0000 for the Version field of the
/// PropertySetStream packet, MUST NOT have a Behavior property.
/// If the Behavior property is present, it MUST have one of the following values.
public enum PropertySetBehavior: UInt32 {
    /// 0x00000000 Property names are case-insensitive (default).
    case caseInsensitive = 0x00000000
    
    /// 0x00000001 Property names are case-sensitive.
    case caseSensitive = 0x00000001
}
