//
//  PropertySet.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.20 PropertySet
/// The PropertySet packet represents a property set.
public struct PropertySet {
    public let size: UInt32
    public let numProperties: UInt32
    public let propertyIdentifierAndOffsets: [PropertyIdentifierAndOffset]
    public let properties: [Property]
    
    public init(dataStream: inout DataStream, startPosition: Int, offset: UInt32) throws {
        let position = startPosition + Int(offset)
        if position > dataStream.count {
            throw PropertySetError.corrupted
        }

        dataStream.position = position
        
        /// Size (4 bytes): MUST be the total size in bytes of the PropertySet packet.
        self.size = try dataStream.read(endianess: .littleEndian)
        
        /// NumProperties (4 bytes): An unsigned integer representing the number of properties in the property set.
        self.numProperties = try dataStream.read(endianess: .littleEndian)
        
        /// PropertyIdentifierAndOffset 0 (variable): All PropertyIdentifierAndOffset fields MUST be a sequence of PropertyIdentifierAndOffset
        /// packets. The sequence MUST be in order of increasing value of the Offset field. Packets are not required to be in any particular
        /// order with regard to the value of the PropertyIdentifier field.
        var codePage: UInt16? = nil
        var propertyIdentifierAndOffsets: [PropertyIdentifierAndOffset] = []
        for _ in 0..<self.numProperties {
            let propertyIdentifierAndOffset = try PropertyIdentifierAndOffset(dataStream: &dataStream)
            propertyIdentifierAndOffsets.append(propertyIdentifierAndOffset)
            
            /// [MS-OLEPS] 2.18.2 CodePage Property
            /// The CodePage property MUST have the property identifier 0x00000001, MUST NOT have a property name, and MUST have type
            /// VT_I2 (0x0002). Every property set MUST have a CodePage property and its value MUST be a valid code page identifier as specified
            /// in [MS-UCODEREF] section 2.2.1. Its value is selected in an implementation-specific manner.<2>
            /// The CodePage property of a property set affects the representation of the CodePageString and DictionaryEntry packets. The value
            /// CP_WINUNICODE (0x04B0) indicates that the strings in these packets are encoded as arrays of 16-bit Unicode characters. Any
            /// other value indicates that the strings in these packets are encoded as arrays of 8-bit characters from the code page identified.
            if propertyIdentifierAndOffset.propertyIdentifier == 0x00000001 {
                let position = startPosition + Int(offset + propertyIdentifierAndOffset.offset)
                if position > dataStream.count {
                    throw PropertySetError.corrupted
                }
                
                let oldPosition = dataStream.position
                dataStream.position = position
                let typedPropertyValue = try TypedPropertyValue(dataStream: &dataStream, codePage: nil)
                guard let codePageProperty = typedPropertyValue.value as? Int16 else {
                    throw PropertySetError.corrupted
                }
                
                codePage = UInt16(bitPattern: codePageProperty)
                dataStream.position = oldPosition
            }
        }
        
        self.propertyIdentifierAndOffsets = propertyIdentifierAndOffsets
        
        /// Property 0 (variable): Each Property field is a sequence of property values, each of which MUST be represented by a
        /// TypedPropertyValue packet or a Dictionary packet in the special case of the Dictionary property.
        var properties: [Property] = []
        properties.reserveCapacity(Int(self.numProperties))
        for element in propertyIdentifierAndOffsets {
            let position = startPosition + Int(offset + element.offset)
            if position > dataStream.count {
                throw PropertySetError.corrupted
            }
            
            dataStream.position = position
            if element.propertyIdentifier != 0x00000000 {
                let typedPropertyValue = try TypedPropertyValue(dataStream: &dataStream, codePage: codePage)
                properties.append(typedPropertyValue)
            } else {
                guard let codePage = codePage else {
                    throw PropertySetError.corrupted
                }
                 
                let dictionary = try Dictionary(dataStream: &dataStream, codePage: codePage)
                properties.append(dictionary)
            }
        }
        
        self.properties = properties
    }
}
