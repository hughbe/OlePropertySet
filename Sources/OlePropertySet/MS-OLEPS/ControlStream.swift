//
//  ControlStream.swift
//  
//
//  Created by Hugh Bellamy on 04/11/2020.
//

import DataStream
import WindowsDataTypes

/// [MS-OLEPS] 2.24.3 Control Stream
/// A file that has one or more property sets associated with it through the alternate stream binding MUST have a control stream, which is an
/// alternate stream with the name "{4c8cc155-6c1e-11d1-8e41-00c04fb9386d}". This stream MUST contain the following packet.
public struct ControlStream {
    public let reserved1: UInt16
    public let reserved2: UInt16
    public let applicationState: UInt32
    public let clsid: GUID
    
    public init(dataStream: inout DataStream) throws {
        /// Reserved1 (2 bytes): MUST be set to zero, and nonzero values MUST be rejected.
        self.reserved1 = try dataStream.read(endianess: .littleEndian)
        if self.reserved1 != 0x0000 {
            throw PropertySetError.corrupted
        }
        
        /// Reserved2 (2 bytes): MUST be set to zero, and MUST be ignored.
        self.reserved2 = try dataStream.read(endianess: .littleEndian)
        
        /// ApplicationState (4 bytes): An application-provided value that MUST NOT be interpreted by the OLEPS implementation. If the
        /// application did not provide a value, it SHOULD be set to zero.
        self.applicationState = try dataStream.read(endianess: .littleEndian)
        
        /// CLSID (16 bytes): An application-provided value that MUST NOT be interpreted by the OLEPS implementation. If the application
        /// did not provide a value, it SHOULD be absent.
        self.clsid = try GUID(dataStream: &dataStream)
    }
}
