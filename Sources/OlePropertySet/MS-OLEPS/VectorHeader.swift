//
//  VectorHeader.swift
//  
//
//  Created by Hugh Bellamy on 04/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.14.2 VectorHeader
/// The VectorHeader packet represents the number of scalar values in a vector property type.
internal struct VectorHeader {
    public let length: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// Length (4 bytes): An unsigned integer indicating the number of scalar values following the header.
        self.length = try dataStream.read(endianess: .littleEndian)
    }
}
