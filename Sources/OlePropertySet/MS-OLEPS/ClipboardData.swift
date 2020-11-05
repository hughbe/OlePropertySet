//
//  ClipboardData.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.11 ClipboardData
/// The ClipboardData packet represents clipboard data.
public struct ClipboardData {
    public let size: UInt32
    public let format: UInt32
    public let data: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position

        /// Size (4 bytes): The total size in bytes of the Format and Data fields, not including padding (if any).
        self.size = try dataStream.read(endianess: .littleEndian)
        
        /// Format (4 bytes): An application-specific identifier for the format of the data in the Data field.
        self.format = try dataStream.read(endianess: .littleEndian)
        
        /// Data (variable): MUST be an array of bytes, followed by zero padding to a multiple of 4 bytes.
        self.data = try dataStream.readBytes(count: Int(self.size))
        try dataStream.readPadding(fromStart: startPosition)
    }
}
