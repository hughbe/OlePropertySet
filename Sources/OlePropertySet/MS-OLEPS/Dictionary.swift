//
//  Dictionary.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.17 Dictionary
/// The Dictionary packet represents all mappings between property identifiers and property names in a property set.
public struct Dictionary {
    public let identifierMapping: [PropertyIdentifier: String]
    public let nameMapping: [String: PropertyIdentifier]
    
    public init(dataStream: inout DataStream, codePage: UInt16) throws {
        let startPosition = dataStream.position

        /// NumEntries (4 bytes): (4 bytes) An unsigned integer representing the number of entries in the Dictionary. self.
        let numEntries: UInt32 = try dataStream.read(endianess: .littleEndian)
        
        /// Entry 1 (variable): All Entry fields MUST be a sequence of DictionaryEntry packets. Entries are not required to appear in any particular order.
        var identifierMapping: [PropertyIdentifier: String] = [:]
        identifierMapping.reserveCapacity(Int(numEntries))
        var nameMapping: [String: PropertyIdentifier] = [:]
        nameMapping.reserveCapacity(Int(numEntries))
        for _ in 0..<numEntries {
            let entry = try DictionaryEntry(dataStream: &dataStream, codePage: codePage)
            identifierMapping[entry.propertyIdentifier] = entry.name
            nameMapping[entry.name] = entry.propertyIdentifier
        }
        
        self.identifierMapping = identifierMapping
        self.nameMapping = nameMapping
        
        /// Padding (variable): Padding, if necessary, to a total length that is a multiple of 4 bytes.
        try dataStream.readPadding(fromStart: startPosition)
    }
}
