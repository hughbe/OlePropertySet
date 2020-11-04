//
//  PropertySetStream.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream
import WindowsDataTypes

/// [MS-OLEPS] 2.21 PropertySetStream
/// The PropertySetStream packet specifies the stream format for simple property sets and the stream format for the CONTENTS stream in the
/// Non-Simple Property Set Storage Format. A simple property set MUST be represented by a stream containing a PropertySetStream packet.
/// The PropertySetStream packet usually represents exactly one property set, but for historical reasons, the DocumentSummaryInfo and
/// UserDefinedProperties property sets are represented in the same stream. In this special case, a PropertySetStream might represent two
/// property sets.
/// An implementation SHOULD enforce a limit on the total size of a PropertySetStream packet. This limit MUST be at least 262,144 bytes, and
/// for maximum interoperability SHOULD<4> be 2,097,152 bytes.
public struct PropertySetStream {
    public let byteOrder: UInt16
    public let version: UInt16
    public let systemIdentifier: UInt32
    public let clsid: GUID
    public let numPropertySets: UInt32
    public let fmtid0: GUID
    public let offset0: UInt32
    public let propertySet0: PropertySet
    public let fmtid1: GUID?
    public let offset1: UInt32?
    public let propertySet1: PropertySet?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// ByteOrder (2 bytes): MUST be set to 0xFFFE.
        self.byteOrder = try dataStream.read(endianess: .littleEndian)
        if self.byteOrder != 0xFFFE {
            throw PropertySetError.corrupted
        }
        
        /// Version (2 bytes): An unsigned integer indicating the version number of the property set (or property sets). MUST be 0x0000 or 0x0001.
        /// An OLEPS implementation MUST accept version 0 property sets and SHOULD<5> also accept version 1 property sets. This field
        /// MUST be set to 0x0001 if the property set or property sets use any of the following features not supported by version 0 property sets:
        ///  Property types not supported for version 0 property sets, as specified in the PropertyType enumeration.
        ///  The Behavior property.
        /// If the property set does not use any of these features, this field SHOULD be set to 0x0000 for maximum interoperability.
        /// Value Meaning
        /// 0x0000 Version 0 property sets will be used.
        /// 0x0001 Version 1 property sets will be used.
        let version: UInt16 = try dataStream.read(endianess: .littleEndian)
        if version != 0x0000 && version != 0x0001 {
            throw PropertySetError.corrupted
        }
        
        self.version = version
        
        /// SystemIdentifier (4 bytes): An implementation-specific<6> value that SHOULD be ignored, except possibly to report this value to
        /// applications. It SHOULD NOT be interpreted by the OLEPS implementation.
        self.systemIdentifier = try dataStream.read(endianess: .littleEndian)
        
        /// CLSID (16 bytes): MUST be a GUID (Packet Version) packet representing the associated CLSID of the property set (or property sets).
        /// If no CLSID is provided by the application, it SHOULD be set to GUID_NULL by default.
        self.clsid = try GUID(dataStream: &dataStream)
        
        /// NumPropertySets (4 bytes): An unsigned integer indicating the number of property sets represented by this PropertySetStream
        /// structure. MUST be either 0x00000001 or 0x00000002.
        /// Value Meaning
        /// 0x00000001 This structure contains one property set.
        /// 0x00000002 This structure contains two property sets. The optional fields for PropertySet 1 are present.
        let numPropertySets: UInt32 = try dataStream.read(endianess: .littleEndian)
        if numPropertySets != 0x00000001 && numPropertySets != 0x00000002 {
            throw PropertySetError.corrupted
        }
        
        self.numPropertySets = numPropertySets
        
        /// FMTID0 (16 bytes): A GUID that MUST be set to the FMTID of the property set represented by the field PropertySet 0. If
        /// NumPropertySets has the value 0x00000002, then this GUID MUST be set to FMTID_DocSummaryInformation
        /// ({D5CDD502-2E9C-101B-9397-08002B2CF9AE}).
        self.fmtid0 = try GUID(dataStream: &dataStream)
        
        /// Offset0 (4 bytes): An unsigned integer that MUST be set to the offset in bytes from the beginning of this PropertySetStream structure
        /// to the beginning of the field PropertySet 0.
        self.offset0 = try dataStream.read(endianess: .littleEndian)
        
        /// FMTID1 (16 bytes): If NumPropertySets has the value 0x00000002, it MUST be set to FMTID_UserDefinedProperties
        /// ({D5CDD505-2E9C-101B-9397-08002B2CF9AE}). Otherwise, it MUST be absent.
        if self.numPropertySets == 0x00000002 {
            self.fmtid1 = try GUID(dataStream: &dataStream)
        } else {
            self.fmtid1 = nil
        }
        
        /// Offset1 (4 bytes): If NumPropertySets has the value 0x00000002, it MUST be set to the offset in bytes from the beginning of this
        /// PropertySetStream structure to the beginning of the field PropertySet 1. Otherwise, it MUST be absent.
        if self.numPropertySets == 0x00000002 {
            self.offset1 = try dataStream.read(endianess: .littleEndian)
        } else {
            self.offset1 = nil
        }
        
        /// PropertySet0 (variable): MUST be a PropertySet packet.
        self.propertySet0 = try PropertySet(dataStream: &dataStream, startPosition: startPosition, offset: self.offset0)
        
        /// PropertySet1 (variable): If NumPropertySets has the value 0x00000002, it MUST be a PropertySet packet. Otherwise, it MUST be
        /// absent.
        if self.numPropertySets == 0x00000002 {
            self.propertySet1 = try PropertySet(dataStream: &dataStream, startPosition: startPosition, offset: self.offset1!)
        } else {
            self.propertySet1 = nil
        }
        
        /// Padding (variable): Contains additional padding added by the implementation. If present, padding MUST be zeroes and MUST be
        /// ignored.
    }
}
