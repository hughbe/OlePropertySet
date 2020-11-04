//
//  PropertyType.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

/// [MS-OLEPS] 2.2 PropertyType
/// The PropertyType enumeration represents the type of a property in a property set. The set of types supported depends on the version of
/// the property set, which is indicated by the Version field of the PropertySetStream packet. In addition, the property types not supported in
/// simple property sets are specified as such. PropertyType is an enumeration, which MUST be one of the following values:
/// This type is declared as follows:
/// typedef unsigned int PropertyType;
public enum PropertyType: UInt16 {
    /// VT_EMPTY 0x0000 Type is undefined, and the minimum property set version is 0.
    case empty = 0x0000

    /// VT_NULL 0x0001 Type is null, and the minimum property set version is 0.
    case null = 0x0001

    /// VT_I2 0x0002 Type is 16-bit signed integer, and the minimum property set version is 0.
    case i2 = 0x0002

    /// VT_I4 0x0003 Type is 32-bit signed integer, and the minimum property set version is 0.
    case i4 = 0x0003

    /// VT_R4 0x0004 Type is 4-byte (single-precision) IEEE floating-point number, and the minimum property set version is 0.
    case r4 = 0x0004

    /// VT_R8 0x0005 Type is 8-byte (double-precision) IEEE floating-point number, and the minimum property set version is 0.
    case r8 = 0x0005

    /// VT_CY 0x0006 Type is CURRENCY, and the minimum property set version is 0.
    case cy = 0x0006

    /// VT_DATE 0x0007 Type is DATE, and the minimum property set version is 0.
    case date = 0x0007

    /// VT_BSTR 0x0008 Type is CodePageString, and the minimum property set version is 0.
    case bstr = 0x0008

    /// VT_ERROR 0x000A Type is HRESULT, and the minimum property set version is 0.
    case error = 0x000A

    /// VT_BOOL 0x000B Type is VARIANT_BOOL, and the minimum property set version is 0.
    case bool = 0x000B

    /// VT_DECIMAL 0x000E Type is DECIMAL, and the minimum property set version is 0.
    case decimal = 0x000E

    /// VT_I1 0x0010 Type is 1-byte signed integer, and the minimum property set version is 1.
    case i1 = 0x0010

    /// VT_UI1 0x0011 Type is 1-byte unsigned integer, and the minimum property set version is 0.
    case ui1 = 0x0011

    /// VT_UI2 0x0012 Type is 2-byte unsigned integer, and the minimum property set version is 0.
    case ui2 = 0x0012

    /// VT_UI4 0x0013 Type is 4-byte unsigned integer, and the minimum property set version is 0.
    case ui4 = 0x0013

    /// VT_I8 Type is 8-byte signed integer, and the minimum property set version is 0. 0x0014
    case i8 = 0x0014
    
    /// VT_UI8 0x0015 Type is 8-byte unsigned integer, and the minimum property set version is 0.
    case ui8 = 0x0015

    /// VT_INT 0x0016 Type is 4-byte signed integer, and the minimum property set version is 1.
    case int = 0x0016

    /// VT_UINT 0x0017 Type is 4-byte unsigned integer, and the minimum property set version is 1.
    case uint = 0x0017

    /// VT_LPSTR 0x001E Type is CodePageString, and the minimum property set version is 0.
    case lpstr = 0x001E

    /// VT_LPWSTR 0x001F Type is UnicodeString, and the minimum property set version is 0.
    case lpwstr = 0x001F

    /// VT_FILETIME 0x0040 Type is FILETIME, and the minimum property set version is 0.
    case filetime = 0x0040

    /// VT_BLOB 0x0041 Type is binary large object (BLOB), and the minimum property set version is 0.
    case blob = 0x0041

    /// VT_STREAM 0x0042 Type is Stream, and the minimum property set version is 0. VT_STREAM is not allowed in a simple property set.
    case stream = 0x0042
    
    /// VT_STORAGE 0x0043 Type is Storage, and the minimum property set version is 0. VT_STORAGE is not allowed in a simple property set.
    case storage = 0x0043
    
    /// VT_STREAMED_Object 0x0044 Type is Stream representing an Object in an application-specific manner, and the minimum property set
    /// version is 0. VT_STREAMED_Object is not allowed in a simple property set.
    case streamedObject = 0x0044
    
    /// VT_STORED_Object 0x0045 Type is Storage representing an Object in an application-specific manner, and the minimum property set
    /// version is 0. VT_STORED_Object is not allowed in a simple property set.
    case storedObject = 0x0045
    
    /// VT_BLOB_Object 0x0046 Type is BLOB representing an object in an application-specific manner. The minimum property set version is 0.
    case blobObject = 0x0046

    /// VT_CF 0x0047 Type is PropertyIdentifier, and the minimum property set version is 0.
    case cf = 0x0047

    /// VT_CLSID 0x0048 Type is CLSID, and the minimum property set version is 0.
    case clsid = 0x0048

    /// VT_VERSIONED_STREAM 0x0049 Type is Stream with application-specific version GUID (VersionedStream). The minimum property set
    /// version is 0. VT_VERSIONED_STREAM is not allowed in a simple property set.
    case versionedStream = 0x0049
    
    /// VT_VECTOR | VT_I2 0x1002 Type is Vector of 16-bit signed integers, and the minimum property set version is 0.
    case vectorI2 = 0x1002

    /// VT_VECTOR | VT_I4 0x1003 Type is Vector of 32-bit signed integers, and the minimum property set version is 0.
    case vectorI4 = 0x1003

    /// VT_VECTOR | VT_R4 0x1004 Type is Vector of 4-byte (single-precision) IEEE floating-point numbers, and the minimum property set version
    /// is 0.
    case vectorR4 = 0x1004

    /// VT_VECTOR | VT_R8 0x1005 Type is Vector of 8-byte (double-precision) IEEE floating-point numbers, and the minimum property set version
    /// is 0.
    case vectorR8 = 0x1005

    /// VT_VECTOR | VT_CY 0x1006 Type is Vector of CURRENCY, and the minimum property set version is 0.
    case vectorCY = 0x1006

    /// VT_VECTOR | VT_DATE 0x1007 Type is Vector of DATE, and the minimum property set version is 0.
    case vectorDate = 0x1007

    /// VT_VECTOR | VT_BSTR 0x1008 Type is Vector of CodePageString, and the minimum property set version is 0.
    case vectorBstr = 0x1008

    /// VT_VECTOR | VT_ERROR 0x100A Type is Vector of HRESULT, and the minimum property set version is 0.
    case vectorError = 0x100A

    /// VT_VECTOR | VT_BOOL 0x100B Type is Vector of VARIANT_BOOL, and the minimum property set version is 0.
    case vectorBool = 0x100B

    /// VT_VECTOR | VT_VARIANT 0x100C Type is Vector of variable-typed properties, and the minimum property set version is 0.
    case vectorVariant = 0x100C

    /// VT_VECTOR | VT_I1 0x1010 Type is Vector of 1-byte signed integers and the minimum property set version is 1.
    case vectorI1 = 0x1010

    /// VT_VECTOR | VT_UI1 0x1011 Type is Vector of 1-byte unsigned integers, and the minimum property set version is 0.
    case vectorUI1 = 0x1011

    /// VT_VECTOR | VT_UI2 0x1012 Type is Vector of 2-byte unsigned integers, and the minimum property set version is 0.
    case vectorUI2 = 0x1012

    /// VT_VECTOR | VT_UI4 0x1013 Type is Vector of 4-byte unsigned integers, and the minimum property set version is 0.
    case vectorUI4 = 0x1013

    /// VT_VECTOR | VT_I8 0x1014 Type is Vector of 8-byte signed integers, and the minimum property set version is 0.
    case vectorI8 = 0x1014

    /// VT_VECTOR | VT_UI8 0x1015 Type is Vector of 8-byte unsigned integers and the minimum property set version is 0.
    case vectorUI8 = 0x1015

    /// VT_VECTOR | VT_LPSTR 0x101E Type is Vector of CodePageString, and the minimum property set version is 0.
    case vectorLpstr = 0x101E

    /// VT_VECTOR | VT_LPWSTR 0x101F Type is Vector of UnicodeString, and the minimum property set version is 0.
    case vectorLpwstr = 0x101F

    /// VT_VECTOR | VT_FILETIME 0x1040 Type is Vector of FILETIME, and the minimum property set version is 0.
    case vectorFiletime = 0x1040

    /// VT_VECTOR | VT_CF 0x1047 Type is Vector of PropertyIdentifier, and the minimum property set version is 0.
    case vectorCF = 0x1047

    /// VT_VECTOR | VT_CLSID 0x1048 Type is Vector of CLSID, and the minimum property set version is 0.
    case vectorClsid = 0x1048
    
    /// VT_ARRAY | VT_I2 0x2002 Type is Array of 16-bit signed integers, and the minimum property set version is 1.
    case arrayI2 = 0x2002

    /// VT_ARRAY | VT_I4 0x2003 Type is Array of 32-bit signed integers, and the minimum property set version is 1.
    case arrayI4 = 0x2003

    /// VT_ARRAY | VT_R4 0x2004 Type is Array of 4-byte (single-precision) IEEE floating-point numbers, and the minimum property set version is 1.
    case arrayR4 = 0x2004

    /// VT_ARRAY | VT_R8 0x2005 Type is IEEE floating-point numbers, and the minimum property set version is 1.
    case arrayR8 = 0x2005

    /// VT_ARRAY | VT_CY 0x2006 Type is Array of CURRENCY, and the minimum property set version is 1.
    case arrayCY = 0x2006

    /// VT_ARRAY | VT_DATE 0x2007 Type is Array of DATE, and the minimum property set version is 1.
    case arrayDate = 0x2007

    /// VT_ARRAY | VT_BSTR 0x2008 Type is Array of CodePageString, and the minimum property set version is 1.
    case arrayBstr = 0x2008

    /// VT_ARRAY | VT_ERROR 0x200A Type is Array of HRESULT, and the minimum property set version is 1.
    case arrayError = 0x200A

    /// VT_ARRAY | VT_BOOL 0x200B Type is Array of VARIANT_BOOL, and the minimum property set version is 1.
    case arrayBool = 0x200B
    
    /// VT_ARRAY | VT_VARIANT 0x200C Type is Array of variable-typed properties, and the minimum property set version is 1.
    case arrayVariant = 0x200C

    /// VT_ARRAY | VT_DECIMAL 0x200E Type is Array of DECIMAL, and the minimum property set version is 1.
    case arrayDecimal = 0x200E

    /// VT_ARRAY | VT_I1 0x2010 Type is Array of 1-byte signed integers, and the minimum property set version is 1.
    case arrayI1 = 0x2010

    /// VT_ARRAY | VT_UI1 0x2011 Type is Array of 1-byte unsigned integers, and the minimum property set version is 1.
    case arrayUI1 = 0x2011

    /// VT_ARRAY | VT_UI2 0x2012 Type is Array of 2-byte unsigned integers, and the minimum property set version is 1.
    case arrayUI2 = 0x2012

    /// VT_ARRAY | VT_UI4 0x2013 Type is Array of 4-byte unsigned integers, and the minimum property set version is 1.
    case arrayUI4 = 0x2013

    /// VT_ARRAY | VT_INT 0x2016 Type is Array of 4-byte signed integers, and the minimum property set version is 1.
    case arrayInt = 0x2016

    /// VT_ARRAY | VT_UINT 0x2017 Type is Array of 4-byte unsigned integers, and the minimum property set version is 1.
    case arrayUInt = 0x2017
}
