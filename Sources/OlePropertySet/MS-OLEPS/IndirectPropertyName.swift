//
//  IndirectPropertyName.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.10 IndirectPropertyName
/// The IndirectPropertyName packet represents the name of a stream or storage as used in the representation of the following property types in a
/// non-simple property set: VT_STREAM (0x0042), VT_STORAGE (0x0043), VT_STREAMED_OBJECT (0x0044), VT_STORED_OBJECT (0x0044),
/// and VT_VERSIONED_STREAM (0x0049). It MUST be represented as a CodePageString, and its value MUST be derived from the property
/// identifier of the property represented according to the following Augmented Backus–Naur Form (ABNF) [RFC4234] syntax.
/// Indirectproperty = "prop" propertyIdentifier
/// Where PropertyIdentifier is the decimal string representation of the property identifier. This property identifier MUST be a valid PropertyIdentifier
/// value and MUST NOT be the property identifier for any of the special properties specified in section 2.18.
public struct IndirectPropertyName {
    public let name: String
    public let type: PropertyType

    public init(dataStream: inout DataStream, codePage: UInt16, isVariant: Bool, type: PropertyType) throws {
        self.name = try CodePageString(dataStream: &dataStream, codePage: codePage, isVariant: isVariant).characters
        self.type = type
    }
}
