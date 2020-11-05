//
//  TypedPropertyValue.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import DataStream
import OleAutomationDataTypes
import WindowsDataTypes

/// [MS-OLEPS] 2.15 TypedPropertyValue
/// The TypedPropertyValue structure represents the typed value of a property in a property set.
internal struct TypedPropertyValue {
    public let type: PropertyType
    public let padding: UInt16
    public let value: Any?
    
    public init(dataStream: inout DataStream, codePage: UInt16?, isVariant: Bool = false) throws {
        let startPosition = dataStream.position

        /// Type (2 bytes): MUST be a value from the PropertyType enumeration, indicating the type of property represented.
        let typeRaw: UInt16 = try dataStream.read(endianess: .littleEndian)
        guard let type = PropertyType(rawValue: typeRaw) else {
            throw PropertySetError.corrupted
        }
        
        self.type = type
        
        /// Padding (2 bytes): MUST be set to zero, and any nonzero value SHOULD be rejected.
        self.padding = try dataStream.read(endianess: .littleEndian)
        
        func readVector<T>(readFunc: (inout DataStream) throws -> T) throws -> [T] {
            let header = try VectorHeader(dataStream: &dataStream)
            var results: [T] = []
            results.reserveCapacity(Int(header.length))
            for _ in 0..<header.length {
                let result = try readFunc(&dataStream)
                results.append(result)
            }

            return results
        }
        func readArray<T>(readFunc: (inout DataStream) throws -> T) throws -> [T] {
            let header = try ArrayHeader(dataStream: &dataStream)
            
            let size = header.dimensions.map { $0.size }.reduce(1, *)
            
            var results: [T] = []
            results.reserveCapacity(Int(size))
            for _ in 0..<size {
                let result = try readFunc(&dataStream)
                results.append(result)
            }

            return results
        }
        
        /// Value (variable): MUST be the value of the property represented and serialized according to the value of Type as follows.
        switch self.type {
        case .empty:
            /// VT_EMPTY (0x0000) MUST be zero bytes in length.
            self.value = nil
        case .null:
            /// VT_NULL (0x0001) MUST be zero bytes in length.
            self.value = nil
        case .i2:
            /// VT_I2 (0x0002) MUST be a 16-bit signed integer, followed by zero padding to 4 bytes.
            self.value = try dataStream.read(endianess: .littleEndian) as Int16
            let _: UInt8 = try dataStream.read()
            let _: UInt8 = try dataStream.read()
        case .i4:
            /// VT_I4 (0x0003) MUST be a 32-bit signed integer.
            self.value = try dataStream.read(endianess: .littleEndian) as Int32
        case .r4:
            /// VT_R4 (0x0004) MUST be a 4-byte (single-precision) IEEE floating-point number.
            self.value = try dataStream.readFloat(endianess: .littleEndian)
        case .r8:
            /// VT_R8 (0x0005) MUST be an 8-byte (double-precision) IEEE floating-point number.
            self.value = try dataStream.readDouble(endianess: .littleEndian)
        case .cy:
            /// VT_CY (0x0006) MUST be a CURRENCY (Packet Version).
            self.value = try CURRENCY(dataStream: &dataStream).doubleValue
        case .date:
            /// VT_DATE (0x0007) MUST be a DATE (Packet Version).
            self.value = try DATE(dataStream: &dataStream).dateValue
        case .bstr:
            /// VT_BSTR (0x0008) MUST be a CodePageString.
            self.value = try CodePageString(dataStream: &dataStream, codePage: codePage, isVariant: isVariant).characters
        case .error:
            /// VT_ERROR (0x000A) MUST be a 32-bit unsigned integer representing an HRESULT, as specified in [MS-DTYP] section 2.2.18.
            self.value = try dataStream.read(endianess: .littleEndian) as HRESULT
        case .bool:
            /// VT_BOOL (0x000B) MUST be a VARIANT_BOOL as specified in [MS-OAUT] section 2.2.27, followed by zero padding to 4 bytes.
            self.value = try VARIANT_BOOL(dataStream: &dataStream).boolValue
        case .decimal:
            /// VT_DECIMAL (0x000E) MUST be a DECIMAL (Packet Version).
            self.value = try DECIMAL(dataStream: &dataStream).doubleValue
        case .i1:
            /// VT_I1 (0x0010) MUST be a 1-byte signed integer, followed by zero padding to 4 bytes.
            self.value = try dataStream.read() as Int8
            let _: UInt8 = try dataStream.read()
            let _: UInt8 = try dataStream.read()
            let _: UInt8 = try dataStream.read()
        case .ui1:
            /// VT_UI1 (0x0011) MUST be a 1-byte unsigned integer, followed by zero padding to 4 bytes.
            self.value = try dataStream.read() as UInt8
            let _: UInt8 = try dataStream.read()
            let _: UInt8 = try dataStream.read()
            let _: UInt8 = try dataStream.read()
        case .ui2:
            /// VT_UI2 (0x0012) MUST be a 2-byte unsigned integer, followed by zero padding to 4 bytes.
            self.value = try dataStream.read() as UInt16
            let _: UInt8 = try dataStream.read()
            let _: UInt8 = try dataStream.read()
        case .ui4:
            /// VT_UI4 (0x0013) MUST be a 4-byte unsigned integer.
            self.value = try dataStream.read() as UInt32
        case .i8:
            /// VT_I8 (0x0014) MUST be an 8-byte signed integer.
            self.value = try dataStream.read() as Int64
        case .ui8:
            /// VT_UI8 (0x0015) MUST be an 8-byte unsigned integer.
            self.value = try dataStream.read() as UInt64
        case .int:
            /// VT_INT (0x0016) MUST be a 4-byte signed integer.
            self.value = try dataStream.read(endianess: .littleEndian) as Int32
        case .uint:
            /// VT_UINT (0x0017) MUST be a 4-byte unsigned integer.
            self.value = try dataStream.read(endianess: .littleEndian) as UInt32
        case .lpstr:
            /// VT_LPSTR (0x001E) MUST be a CodePageString.
            self.value = try CodePageString(dataStream: &dataStream, codePage: codePage, isVariant: isVariant).characters
        case .lpwstr:
            /// VT_LPWSTR (0x001F) MUST be a UnicodeString.
            self.value = try UnicodeString(dataStream: &dataStream, isVariant: isVariant).characters
        case .filetime:
            /// VT_FILETIME (0x0040) MUST be a FILETIME (Packet Version).
            self.value = try FILETIME(dataStream: &dataStream).date
        case .blob:
            /// VT_BLOB (0x0041) MUST be a BLOB.
            self.value = try BLOB(dataStream: &dataStream).bytes
        case .stream:
            /// VT_STREAM (0x0042) MUST be an IndirectPropertyName. The storage representing the (nonsimple) property set MUST have a
            /// stream element with this name.
            self.value = try IndirectPropertyName(dataStream: &dataStream, codePage: codePage, isVariant: isVariant, type: type)
        case .storage:
            /// VT_STORAGE (0x0043) MUST be an IndirectPropertyName. The storage representing the (nonsimple) property set MUST have
            /// a storage element with this name.
            self.value = try IndirectPropertyName(dataStream: &dataStream, codePage: codePage, isVariant: isVariant, type: type)
        case .streamedObject:
            /// VT_STREAMED_OBJECT (0x0044) MUST be an IndirectPropertyName. The storage representing the (nonsimple) property set
            /// MUST have a stream element with this name.
            self.value =  try IndirectPropertyName(dataStream: &dataStream, codePage: codePage, isVariant: isVariant, type: type)
        case .storedObject:
            /// VT_STORED_OBJECT (0x0045) MUST be an IndirectPropertyName. The storage representing the (nonsimple) property set
            /// MUST have a storage element with this name.
            self.value =  try IndirectPropertyName(dataStream: &dataStream, codePage: codePage, isVariant: isVariant, type: self.type)
        case .blobObject:
            /// VT_BLOB_OBJECT (0x0046) MUST be a BLOB.
            self.value = try BLOB(dataStream: &dataStream).bytes
        case .cf:
            /// VT_CF (0x0047) MUST be a ClipboardData.
            self.value = try ClipboardData(dataStream: &dataStream)
        case .clsid:
            /// VT_CLSID (0x0048) MUST be a GUID (Packet Version).
            self.value = try GUID(dataStream: &dataStream)
        case .versionedStream:
            /// VT_VERSIONED_STREAM (0x0049) MUST be a VersionedStream. The storage representing the (non-simple) property set MUST have a
            /// stream element with the name in the StreamName field.
            self.value = try VersionedStream(dataStream: &dataStream, codePage: codePage, isVariant: isVariant)
        case .vectorI2:
            /// VT_VECTOR | VT_I2 (0x1002) MUST be a VectorHeader followed by a sequence of 16-bit signed integers, followed by zero padding to a
            /// total length that is a multiple of 4 bytes.
            self.value = try readVector { try $0.read(endianess: .littleEndian) as Int16 }
        case .vectorI4:
            /// VT_VECTOR | VT_I4 (0x1003) MUST be a VectorHeader followed by a sequence of 32-bit signed integers.
            self.value = try readVector { try $0.read(endianess: .littleEndian) as Int32 }
        case .vectorR4:
            /// VT_VECTOR | VT_R4 (0x1004) MUST be a VectorHeader followed by a sequence of 4-byte (singleprecision) IEEE floating-point numbers.
            self.value = try readVector { try $0.readFloat(endianess: .littleEndian) }
        case .vectorR8:
            /// VT_VECTOR | VT_R8 (0x1005) MUST be a VectorHeader followed by a sequence of 8-byte (doubleprecision) IEEE floating-point numbers.
            self.value = try readVector { try $0.readDouble(endianess: .littleEndian) }
        case .vectorCY:
            /// VT_VECTOR | VT_CY (0x1006) MUST be a VectorHeader followed by a sequence of CURRENCY (Packet Version) packets.
            self.value = try readVector { try CURRENCY(dataStream: &$0).doubleValue }
        case .vectorDate:
            /// VT_VECTOR | VT_DATE (0x1007) MUST be a VectorHeader followed by a sequence of DATE (Packet Version) packets.
            self.value = try readVector { try DATE(dataStream: &$0).dateValue }
        case .vectorBstr:
            /// VT_VECTOR | VT_BSTR (0x1008) MUST be a VectorHeader followed by a sequence of CodePageString packets.
            self.value = try readVector { try CodePageString(dataStream: &$0, codePage: codePage, isVariant: true).characters }
        case .vectorError:
            /// VT_VECTOR | VT_ERROR (0x100A) MUST be a VectorHeader followed by a sequence of 32-bit unsigned integers representing HRESULTs,
            /// as specified in [MS-DTYP] section 2.2.18.
            self.value = try readVector { try $0.read(endianess: .littleEndian) as HRESULT }
        case .vectorBool:
            /// VT_VECTOR | VT_BOOL (0x100B) MUST be a VectorHeader followed by a sequence of VARIANT_BOOL as specified in [MS-OAUT]
            /// section 2.2.27, followed by zero padding to a total length that is a multiple of 4 bytes.
            self.value = try readVector { try VARIANT_BOOL(dataStream: &$0).boolValue }
        case .vectorVariant:
            /// VT_VECTOR | VT_VARIANT (0x100C) MUST be a VectorHeader followed by a sequence of TypedPropertyValue packets.
            self.value = try readVector { try TypedPropertyValue(dataStream: &$0, codePage: codePage, isVariant: true).value }
        case .vectorI1:
            /// VT_VECTOR | VT_I1 (0x1010) MUST be a VectorHeader followed by a sequence of 1-byte signed integers, followed by zero padding to a
            /// total length that is a multiple of 4 bytes.
            self.value = try readVector { try $0.read() as Int8 }
        case .vectorUI1:
            /// VT_VECTOR | VT_UI1 (0x1011) MUST be a VectorHeader followed by a sequence of 1-byte unsigned integers, followed by zero padding
            /// to a total length that is a multiple of 4 bytes.
            self.value = try readVector { try $0.read() as UInt8 }
        case .vectorUI2:
            /// VT_VECTOR | VT_UI2 (0x1012) MUST be a VectorHeader followed by a sequence of 2-byte unsigned integers, followed by zero padding
            /// to a total length that is a multiple of 4 bytes.
            self.value = try readVector { try $0.read(endianess: .littleEndian) as UInt16 }
        case .vectorUI4:
            /// VT_VECTOR | VT_UI4 (0x1013) MUST be a VectorHeader followed by a sequence of 4-byte unsigned integers.
            self.value = try readVector { try $0.read(endianess: .littleEndian) as UInt32 }
        case .vectorI8:
            /// VT_VECTOR | VT_I8 (0x1014) MUST be a VectorHeader followed by a sequence of 8-byte signed integers.
            self.value = try readVector { try $0.read(endianess: .littleEndian) as Int64 }
        case .vectorUI8:
            /// VT_VECTOR | VT_UI8 (0x1015) MUST be a VectorHeader followed by a sequence of 8-byte unsigned integers.
            self.value = try readVector { try $0.read(endianess: .littleEndian) as UInt64 }
        case .vectorLpstr:
            /// VT_VECTOR | VT_LPSTR (0x101E) MUST be a VectorHeader followed by a sequence of CodePageString packets.
            self.value = try readVector { try CodePageString(dataStream: &$0, codePage: codePage, isVariant: true).characters }
        case .vectorLpwstr:
            /// VT_VECTOR | VT_LPWSTR (0x101F) MUST be a VectorHeader followed by a sequence of UnicodeString packets.
            self.value = try readVector { try UnicodeString(dataStream: &$0, isVariant: true).characters }
        case .vectorFiletime:
            /// VT_VECTOR | VT_FILETIME (0x1040) MUST be a VectorHeader followed by a sequence of FILETIME (Packet Version) packets.
            self.value = try readVector { try FILETIME(dataStream: &$0).date }
        case .vectorCF:
            /// VT_VECTOR | VT_CF (0x1047) MUST be a VectorHeader followed by a sequence of ClipboardData packets.
            self.value = try readVector { try ClipboardData(dataStream: &$0) }
        case .vectorClsid:
            /// VT_VECTOR | VT_CLSID (0x1048) MUST be a VectorHeader followed by a sequence of GUID (Packet Version) packets.
            self.value = try readVector { try GUID(dataStream: &$0) }
        case .arrayI2:
            /// VT_ARRAY | VT_I2 (0x2002) MUST be an ArrayHeader followed by a sequence of 16-bit signed integers, followed by zero
            /// padding to a total length that is a multiple of 4 bytes.
            self.value = try readArray { try $0.read(endianess: .littleEndian) as Int16 }
        case .arrayI4:
            /// VT_ARRAY | VT_I4 (0x2003) MUST be an ArrayHeader followed by a sequence of 32-bit signed integers.
            self.value = try readArray { try $0.read(endianess: .littleEndian) as Int32 }
        case .arrayR4:
            /// VT_ARRAY | VT_R4 (0x2004) MUST be an ArrayHeader followed by a sequence of 4-byte (singleprecision) IEEE floating-point
            /// numbers.
            self.value = try readArray { try $0.readFloat(endianess: .littleEndian) }
        case .arrayR8:
            /// VT_ARRAY | VT_R8 (0x2005) MUST be an ArrayHeader followed by a sequence of 8-byte (doubleprecision) IEEE floating-point
            /// numbers.
            self.value = try readArray { try $0.readDouble(endianess: .littleEndian) }
        case .arrayCY:
            /// VT_ARRAY | VT_CY (0x2006) MUST be an ArrayHeader followed by a sequence of CURRENCY (Packet Version) packets.ers.
            self.value = try readArray { try CURRENCY(dataStream: &$0).doubleValue }
        case .arrayDate:
            /// VT_ARRAY | VT_DATE (0x2007) MUST be an ArrayHeader followed by a sequence of DATE (Packet Version) packets.
            self.value = try readArray { try DATE(dataStream: &$0).dateValue }
        case .arrayBstr:
            /// VT_ARRAY | VT_BSTR (0x2008) MUST be an ArrayHeader followed by a sequence of CodePageString packets.
            self.value = try readArray { try CodePageString(dataStream: &$0, codePage: codePage, isVariant: true) }
        case .arrayError:
            /// VT_ARRAY | VT_ERROR (0x200A) MUST be an ArrayHeader followed by a sequence of 32-bit unsigned integers representing HRESULTs,
            /// as specified in [MS-DTYP] section 2.2.18.
            self.value = try readArray { try $0.read(endianess: .littleEndian) as HRESULT }
        case .arrayBool:
            /// VT_ARRAY | VT_BOOL (0x200B) MUST be an ArrayHeader followed by a sequence of VARIANT_BOOL as specified in [MS-OAUT]
            /// section 2.2.27, followed by zero padding to a total length that is a multiple of 4 bytes.
            self.value = try readArray { try VARIANT_BOOL(dataStream: &$0).boolValue }
        case .arrayVariant:
            /// VT_ARRAY | VT_VARIANT (0x200C) MUST be an ArrayHeader followed by a sequence of TypedPropertyValue packets.
            self.value = try readArray { try TypedPropertyValue(dataStream: &$0, codePage: codePage, isVariant: true).value }
        case .arrayDecimal:
            /// VT_ARRAY | VT_DECIMAL (0x200E) MUST be an ArrayHeader followed by a sequence of DECIMAL (Packet Version) packets.
            self.value = try readArray { try DECIMAL(dataStream: &$0).doubleValue }
        case .arrayI1:
            /// VT_ARRAY | VT_I1 (0x2010) MUST be an ArrayHeader followed by a sequence of 1-byte signed integers, followed by zero padding to a
            /// total length that is a multiple of 4 bytes.
            self.value = try readArray { try $0.read() as Int8 }
        case .arrayUI1:
            /// VT_ARRAY | VT_UI1 (0x2011) MUST be an ArrayHeader followed by a sequence of 1-byte unsigned integers, followed by zero padding
            /// to a total length that is a multiple of 4 bytes
            self.value = try readArray { try $0.read() as UInt8 }
        case .arrayUI2:
            /// VT_ARRAY | VT_UI2 (0x2012) MUST be an ArrayHeader followed by a sequence of 2-byte unsigned integers, followed by zero padding
            /// to a total length that is a multiple of 4 bytes.
            self.value = try readArray { try $0.read() as UInt16 }
        case .arrayUI4:
            /// VT_ARRAY | VT_UI4 (0x2013) MUST be an ArrayHeader followed by a sequence of 4-byte unsigned integers.
            self.value = try readArray { try $0.read() as UInt32 }
        case .arrayInt:
            /// VT_ARRAY | VT_INT (0x2016) MUST be an ArrayHeader followed by a sequence of 4-byte signed integers.
            self.value = try readArray { try $0.read() as Int32 }
        case .arrayUInt:
            /// VT_ARRAY | VT_UINT (0x2017) MUST be an ArrayHeader followed by a sequence of 4-byte unsigned integers.
            self.value = try readArray { try $0.read() as UInt32 }
        }
        
        if !isVariant && self.type != .vectorVariant && self.type != .arrayVariant {
            try dataStream.readPadding(fromStart: startPosition)
        }
    }
}
