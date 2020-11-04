//
//  ArrayDimension.swift
//  
//
//  Created by Hugh Bellamy on 04/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.14.3 ArrayDimension
/// The ArrayDimension packet represents the size and index offset of a dimension of an array property type.
public struct ArrayDimension {
    public let size: UInt32
    public let indexOffset: UInt32
    
    public init(dataStream: inout DataStream) throws {
        /// Size (4 bytes): An unsigned integer representing the size of the dimension.
        self.size = try dataStream.read(endianess: .littleEndian)
        
        /// IndexOffset (4 bytes): A signed integer representing the index offset of the dimension. For example, an array dimension that is to
        /// be accessed with a 0-based index would have the value zero, whereas an array dimension that is to be accessed with a 1-based
        /// index would have the value 0x00000001.
        /// Value Meaning
        /// 0 An array dimension that is to be accessed with a 0-based index would have the value zero.
        /// 0x00000001 An array dimension that is to be accessed with a 1-based index would have the value 0x00000001.
        self.indexOffset = try dataStream.read(endianess: .littleEndian)
    }
}
