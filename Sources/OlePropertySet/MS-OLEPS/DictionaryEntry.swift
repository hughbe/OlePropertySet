//
//  DictionaryEntry.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.16 DictionaryEntry
/// The DictionaryEntry packet represents a mapping between a property identifier and a property name.
public struct DictionaryEntry {
    public let propertyIdentifier: PropertyIdentifier
    public let length: UInt32
    public let name: String
    
    public init(dataStream: inout DataStream, codePage: UInt16) throws {
        /// PropertyIdentifier (4 bytes): An unsigned integer representing a property identifier. MUST be a valid PropertyIdentifier value in the range
        /// 0x00000002 to 0x7FFFFFFF, inclusive (this specifically excludes the property identifiers for any of the special properties specified in
        /// section 2.18).
        let propertyIdentifier: PropertyIdentifier = try dataStream.read(endianess: .littleEndian)
        if propertyIdentifier < 0x00000002 || propertyIdentifier > 0x7FFFFFFF {
            throw PropertySetError.corrupted
        }
        
        self.propertyIdentifier = propertyIdentifier
        
        /// Length (4 bytes): If the property set's CodePage property has the value CP_WINUNICODE (0x04B0), MUST be the length of the Name
        /// field in 16-bit Unicode characters, including the null terminator but not including padding (if any). Otherwise, MUST be the length of the
        /// Name field in 8-bit characters, including the null terminator.
        self.length = try dataStream.read(endianess: .littleEndian)
        
        /// Name (variable): If the property set's CodePage property has the value CP_WINUNICODE (0x04B0), MUST be a null-terminated array of
        /// 16-bit Unicode characters, followed by zero padding to a multiple of 4 bytes. Otherwise, MUST be a null-terminated array of 8-bit
        /// characters from the code page identified by the CodePage property and MUST NOT be padded.
        if codePage == CodePageString.CP_WINUNICODE {
            let position = dataStream.position
            self.name = try dataStream.readString(count: Int(self.length * 2) - 2, encoding: .utf16LittleEndian)!
            dataStream.position += 2
            let excessBytes = (dataStream.position - position) % 4
            if excessBytes != 0 {
                dataStream.position += 4 - excessBytes
            }
        } else {
            self.name = try dataStream.readString(count: Int(self.length) - 1, encoding: .ascii)!
            dataStream.position += 1
        }
    }
}
