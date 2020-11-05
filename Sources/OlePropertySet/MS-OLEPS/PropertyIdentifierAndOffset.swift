//
//  PropertyIdentifierAndOffset.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.19 PropertyIdentifierAndOffset
/// The PropertyIdentifierAndOffset packet is used in the PropertySet packet to represent a property identifier and the byte offset of the
/// property in the PropertySet packet.
internal struct PropertyIdentifierAndOffset {
    public let propertyIdentifier: PropertyIdentifier
    public let offset: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// PropertyIdentifier (4 bytes): An unsigned integer representing the property identifier of a property in the property set. MUST be a
        /// valid PropertyIdentifier value.
        self.propertyIdentifier = try dataStream.read(endianess: .littleEndian)
        
        /// Offset (4 bytes): An unsigned integer representing the offset in bytes from the beginning of the PropertySet packet to the beginning
        /// of the Property field for the property represented. MUST be a multiple of 4 bytes.
        self.offset = try dataStream.read(endianess: .littleEndian)
    }
}
