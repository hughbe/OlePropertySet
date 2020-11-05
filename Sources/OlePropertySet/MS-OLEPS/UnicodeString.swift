//
//  UnicodeString.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.7 UnicodeString
/// The UnicodeString packet represents a Unicode string.
internal struct UnicodeString {
    public let length: UInt32
    public let characters: String
    
    public init(dataStream: inout DataStream, isVariant: Bool) throws {
        /// Length (4 bytes): The length in 16-bit Unicode characters of the Characters field, including the null terminator, but not including
        /// padding (if any).
        self.length = try dataStream.read(endianess: .littleEndian)
        
        /// Characters (variable): If Length is zero, this field MUST be zero bytes in length. If Length is nonzero, this field MUST be a
        /// null-terminated array of 16-bit Unicode characters, followed by zero padding to a multiple of 4 bytes. The string represented by this
        /// field SHOULD NOT contain embedded or additional trailing null characters.
        if self.length == 0 {
            self.characters = ""
        } else {
            let startPosition = dataStream.position
            self.characters = try dataStream.readString(count: Int(self.length) - 1, encoding: .utf16LittleEndian)!
            
            let newPosition = dataStream.position + 2
            if newPosition > dataStream.count {
                throw PropertySetError.corrupted
            }

            dataStream.position = newPosition
            
            try dataStream.readPadding(fromStart: startPosition)
        }
    }
}
