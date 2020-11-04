//
//  VersionedStream.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream
import WindowsDataTypes

/// [MS-OLEPS] 2.13 VersionedStream
/// The VersionedStream packet represents a stream with an application-specific version GUID.
public struct VersionedStream {
    public let versionGuid: GUID
    public let streamName: IndirectPropertyName
    
    public init(dataStream: inout DataStream, codePage: UInt16, isVariant: Bool) throws {
        /// VersionGuid (16 bytes): MUST be a GUID (Packet Version).
        self.versionGuid = try GUID(dataStream: &dataStream)
        
        /// StreamName (variable): MUST be an IndirectPropertyName.
        self.streamName = try IndirectPropertyName(dataStream: &dataStream, codePage: codePage, isVariant: isVariant, type: .versionedStream)
    }
}
