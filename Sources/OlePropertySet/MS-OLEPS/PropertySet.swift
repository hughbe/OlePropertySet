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
    public let dictionary: Dictionary?
    public let properties: [PropertyIdentifier: Any?]
    
    public let codePage: UInt16?
    public let locale: UInt32?
    public let behavior: PropertySetBehavior
    
    public func getProperty<T>(id: PropertyIdentifier) -> T? {
        return properties[id] as? T
    }
    
    public func getProperty<T>(name: String) -> T? {
        guard let id = dictionary?.nameMapping[name] else {
            return nil
        }

        return getProperty(id: id)
    }
    
    public init(dataStream: inout DataStream, startPosition: Int, offset: UInt32) throws {
        let position = startPosition + Int(offset)
        if position > dataStream.count {
            throw PropertySetError.corrupted
        }

        dataStream.position = position
        
        /// Size (4 bytes): MUST be the total size in bytes of the PropertySet packet.
        let _: UInt32 = try dataStream.read(endianess: .littleEndian)
        
        /// NumProperties (4 bytes): An unsigned integer representing the number of properties in the property set.
        let numProperties: UInt32 = try dataStream.read(endianess: .littleEndian)
        
        func getPropertyValue(element: PropertyIdentifierAndOffset) throws -> Any? {
            let oldPosition = dataStream.position
            let position = startPosition + Int(offset + element.offset)
            if position > dataStream.count {
                throw PropertySetError.corrupted
            }
            
            dataStream.position = position
            
            let typedPropertyValue = try TypedPropertyValue(dataStream: &dataStream, codePage: codePage)
            
            dataStream.position = oldPosition
            return typedPropertyValue.value
        }
        
        /// PropertyIdentifierAndOffset 0 (variable): All PropertyIdentifierAndOffset fields MUST be a sequence of PropertyIdentifierAndOffset
        /// packets. The sequence MUST be in order of increasing value of the Offset field. Packets are not required to be in any particular
        /// order with regard to the value of the PropertyIdentifier field.
        var propertyIdentifierAndOffsets: [PropertyIdentifierAndOffset] = []
        propertyIdentifierAndOffsets.reserveCapacity(Int(numProperties))
        
        var dictionary: Dictionary?
        var codePage: UInt16?
        var locale: UInt32?
        var behavior: PropertySetBehavior = .caseInsensitive
        for _ in 0..<numProperties {
            let propertyIdentifierAndOffset = try PropertyIdentifierAndOffset(dataStream: &dataStream)
            propertyIdentifierAndOffsets.append(propertyIdentifierAndOffset)
            
            if propertyIdentifierAndOffset.propertyIdentifier == CODEPAGE_PROPERTY_IDENTIFIER {
                /// [MS-OLEPS] 2.18.2 CodePage Property
                /// The CodePage property MUST have the property identifier 0x00000001, MUST NOT have a property name, and MUST have type
                /// VT_I2 (0x0002). Every property set MUST have a CodePage property and its value MUST be a valid code page identifier as specified
                /// in [MS-UCODEREF] section 2.2.1. Its value is selected in an implementation-specific manner.<2>
                /// The CodePage property of a property set affects the representation of the CodePageString and DictionaryEntry packets. The value
                /// CP_WINUNICODE (0x04B0) indicates that the strings in these packets are encoded as arrays of 16-bit Unicode characters. Any
                /// other value indicates that the strings in these packets are encoded as arrays of 8-bit characters from the code page identified.
                if let value = try getPropertyValue(element: propertyIdentifierAndOffset) as? Int16 {
                    codePage = UInt16(bitPattern: value)
                }
            } else if propertyIdentifierAndOffset.propertyIdentifier == LOCALE_PROPERTY_IDENTIFIER {
                /// [MS-OLEPS] 2.18.3 Locale Property
                /// The Locale property, if present, MUST have the property identifier 0x80000000, MUST NOT have a property name, and
                /// MUST have type VT_UI4 (0x0013). If present, its value MUST be a valid language code identifier as specified in [MS-LCID].
                /// Its value is selected in an implementation-specific manner.<3>
                if let value = try getPropertyValue(element: propertyIdentifierAndOffset) as? UInt32 {
                    locale = value
                }
            } else if propertyIdentifierAndOffset.propertyIdentifier == BEHAVIOR_PROPERTY_IDENTIFIER {
                /// [MS-OLEPS] 2.18.4 Behavior Property
                /// The Behavior property, if present, MUST have the property identifier 0x80000003, MUST NOT have a property name, and
                /// MUST have type VT_UI4 (0x0013). A version 0 property set, indicated by the value 0x0000 for the Version field of the
                /// PropertySetStream packet, MUST NOT have a Behavior property.
                /// If the Behavior property is present, it MUST have one of the following values.
                /// Value Meaning
                /// 0x00000000 Property names are case-insensitive (default).
                /// 0x00000001 Property names are case-sensitive.
                if let rawValue = try getPropertyValue(element: propertyIdentifierAndOffset) as? UInt32,
                   let value = PropertySetBehavior(rawValue: rawValue) {
                    behavior = value
                }
            }
        }
        
        /// Property 0 (variable): Each Property field is a sequence of property values, each of which MUST be represented by a
        /// TypedPropertyValue packet or a Dictionary packet in the special case of the Dictionary property.
        var properties: [PropertyIdentifier: Any?] = [:]
        properties.reserveCapacity(Int(numProperties))
        for element in propertyIdentifierAndOffsets {
            if element.propertyIdentifier == DICTIONARY_PROPERTY_IDENTIFIER {
                /// [MS-OLEPS] 2.18.1 Dictionary Property
                /// The Dictionary property, if present, MUST have a property identifier of 0x00000000 and MUST NOT have a property name.
                /// Unlike other properties, which are represented as TypedPropertyValue packets, the Dictionary property MUST be represented
                /// s a Dictionary packet. A property set in which any properties have property names MUST have a Dictionary property.
                /// The Dictionary property MUST NOT have multiple entries with the same property identifier or multiple entries with the same
                /// property name. Property names MUST be compared in a case-insensitive manner unless the property set has a Behavior
                /// property with the value 0x00000001, in which case property names MUST be compared in a case-sensitive manner.
                guard let codePage = codePage else {
                    throw PropertySetError.corrupted
                }
                
                let oldPosition = dataStream.position
                let position = startPosition + Int(offset + element.offset)
                if position > dataStream.count {
                    throw PropertySetError.corrupted
                }
                
                dataStream.position = position
                dictionary = try Dictionary(dataStream: &dataStream, codePage: codePage)
                dataStream.position = oldPosition
            } else {
                properties[element.propertyIdentifier] = try getPropertyValue(element: element)
            }
        }

        self.properties = properties
        self.dictionary = dictionary
        self.codePage = codePage
        self.locale = locale
        self.behavior = behavior
    }
}
