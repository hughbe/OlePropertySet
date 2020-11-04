//
//  CodePageString.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.5 CodePageString
/// The CodePageString packet represents a string whose encoding depends on the value of the property set's CodePage property.
public struct CodePageString {
    public static let CP_WINUNICODE: Int16 = 0x04B0
    public let size: UInt32
    public let characters: String
    
    public init(dataStream: inout DataStream, codePage: UInt16, isVariant: Bool) throws {
        /// Size (4 bytes): The size in bytes of the Characters field, including the null terminator, but not including padding (if any). If the property set's
        /// CodePage property has the value CP_WINUNICODE (0x04B0), then the value MUST be a multiple of 2.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        if codePage == CodePageString.CP_WINUNICODE && (size % 2) != 0 {
            throw PropertySetError.corrupted
        }
        
        self.size = size
        
        /// Characters (variable): If Size is zero, this field MUST be zero bytes in length. If Size is nonzero and the CodePage property set's CodePage
        /// property has the value CP_WINUNICODE (0x04B0), then the value MUST be a null-terminated array of 16-bit Unicode characters, followed
        /// by zero padding to a multiple of 4 bytes. If Size is nonzero and the property set's CodePage property has any other value, it MUST be a
        /// null-terminated array of 8-bit characters from the code page identified by the CodePage property, followed by zero padding to a multiple
        /// of 4 bytes. The string represented by this field MAY contain embedded or additional trailing null characters and an OLEPS implementation
        /// MUST be able to handle such strings. However, the manner in which strings with embedded or additional trailing null characters are
        /// presented by the implementation to an application is implementation-specific.<1> For maximum interoperability, an OLEPS implementation
        /// SHOULD NOT write strings with embedded or trailing null characters unless specifically requested to do so by an application.
        if self.size == 0 {
            self.characters = ""
        } else {
            let position = dataStream.position
            if codePage == CodePageString.CP_WINUNICODE {
                self.characters = try dataStream.readString(count: Int(self.size) - 2, encoding: .utf16LittleEndian)!
                dataStream.position += 2
            } else {
                self.characters = try dataStream.readString(count: Int(self.size) - 1, encoding: .ascii)!
                dataStream.position += 1
            }
            
            if !isVariant {
                let excessBytes = (dataStream.position - position) % 4
                if excessBytes != 0 {
                    dataStream.position += excessBytes
                }
            }
        }
    }
}
