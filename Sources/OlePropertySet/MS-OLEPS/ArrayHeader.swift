//
//  ArrayHeader.swift
//  
//
//  Created by Hugh Bellamy on 04/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.14.4 ArrayHeader
/// The ArrayHeader packet represents the type and dimensions of an array property type.
internal struct ArrayHeader {
    public let type: UInt32
    public let numDimensions: UInt32
    public let dimensions: [ArrayDimension]
    
    public init(dataStream: inout DataStream) throws {
        /// Type (4 bytes): MUST be set to the value obtained by clearing the VT_ARRAY (0x2000) bit of this array property's PropertyType value.
        self.type = try dataStream.read(endianess: .littleEndian)
        
        /// NumDimensions (4 bytes): An unsigned integer representing the number of dimensions in the array property. MUST be at least 1
        /// and at most 31.
        /// Value Meaning
        /// 1 — 31 An unsigned integer representing the number of dimensions in the array property.
        let numDimensions: UInt32 = try dataStream.read(endianess: .littleEndian)
        if numDimensions < 1 || numDimensions > 31 {
            throw PropertySetError.corrupted
        }
        
        self.numDimensions = numDimensions
        
        /// Dimension 0 (variable): MUST be a sequence of ArrayDimension packets.
        /// The number of scalar values in an array property can be calculated from the ArrayHeader packet as the product of the Size
        /// fields of each of the ArrayDimension packets.
        var dimensions: [ArrayDimension] = []
        dimensions.reserveCapacity(Int(self.numDimensions))
        for _ in 0..<self.numDimensions {
            let dimension = try ArrayDimension(dataStream: &dataStream)
            dimensions.append(dimension)
        }
        
        self.dimensions = dimensions
    }
}
