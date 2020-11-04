//
//  Dictionary.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream

/// [MS-OLEPS] 2.17 Dictionary
/// The Dictionary packet represents all mappings between property identifiers and property names in a property set.
public struct Dictionary: Property {
    public let numEntries: UInt32
    public let entries: [DictionaryEntry]
    
    public var value: Any? {
        entries
    }
    
    public init(dataStream: inout DataStream, codePage: UInt16) throws {
        let position = dataStream.position

        /// NumEntries (4 bytes): (4 bytes) An unsigned integer representing the number of entries in the Dictionary. self.
        self.numEntries = try dataStream.read(endianess: .littleEndian)
        
        /// Entry 1 (variable): All Entry fields MUST be a sequence of DictionaryEntry packets. Entries are not required to appear in any particular order.
        var entries: [DictionaryEntry] = []
        for _ in 0..<self.numEntries {
            let entry = try DictionaryEntry(dataStream: &dataStream, codePage: codePage)
            entries.append(entry)
        }
        
        self.entries = entries
        
        /// Padding (variable): Padding, if necessary, to a total length that is a multiple of 4 bytes.
        let excessBytes = (dataStream.position - position) % 4
        if excessBytes != 0 {
            dataStream.position += excessBytes
        }
    }
}
