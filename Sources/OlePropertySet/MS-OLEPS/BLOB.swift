//
//  BLOB.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.9 BLOB
/// The BLOB packet represents binary data.
public struct BLOB {
    public let size: UInt32
    public let bytes: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        /// Size (4 bytes): The size in bytes of the Bytes field, not including padding (if any).
        self.size = try dataStream.read(endianess: .littleEndian)
        
        /// Bytes (variable): MUST be an array of bytes, followed by zero padding to a multiple of 4 bytes.
        let position = dataStream.position
        self.bytes = try dataStream.readBytes(count: Int(self.size))
        
        let excessBytes = (dataStream.position - position) % 4
        if excessBytes != 0 {
            dataStream.position += excessBytes
        }
    }
}
