//
//  SummaryInformation.swift
//  
//
//  Created by Hugh Bellamy on 05/11/2020.
//

import DataStream
import Foundation

/// [MS-OLEPS] 2.25 Well-Known Property Set Formats
/// The following sections specify the well-known property set formats PropertyIdentifier and PropertyBag.
/// [MS-OLEPS] 2.25.1 SummaryInformation
/// The SummaryInformation property set format, identified by FMTID_SummaryInformation ({F29F85E0-4FF9-1068-AB91-08002B27B3D9}),
/// represents generic properties of a document. The properties specific to the SummaryInformation property set are specified in the
/// following table. Except where otherwise stated, a SummaryInformation property set SHOULD have all of these properties, and
/// SHOULD NOT have any other properties, except for the special properties specified in section 2.18.
public struct SummaryInformation {
    public let propertySetStream: PropertySetStream
    
    public init(dataStream: inout DataStream) throws {
        try self.init(propertySetStream: try PropertySetStream(dataStream: &dataStream))
    }
    
    public init(propertySetStream: PropertySetStream) throws {
        if propertySetStream.fmtid0 != FMTID_SummaryInformation {
            throw PropertySetError.invalidFmtid(expected: FMTID_SummaryInformation, actual: propertySetStream.fmtid0)
        }
        
        self.propertySetStream = propertySetStream
    }
    
    public var codePage: UInt16? {
        propertySetStream.propertySet0.codePage
    }
    
    public var locale: UInt32? {
        propertySetStream.propertySet0.locale
    }
    
    public var behavior: PropertySetBehavior {
        propertySetStream.propertySet0.behavior
    }
    
    public var title: String? {
        getProperty(id: .title)
    }
    
    public var subject: String? {
        getProperty(id: .subject)
    }
    
    public var author: String? {
        getProperty(id: .author)
    }
    
    public var keywords: String? {
        getProperty(id: .keywords)
    }
    
    public var comments: String? {
        getProperty(id: .comments)
    }
    
    public var template: String? {
        getProperty(id: .template)
    }
    
    public var lastAuthor: String? {
        getProperty(id: .lastAuthor)
    }
    
    public var revisionNumber: String? {
        getProperty(id: .revNumber)
    }
    
    public var editTime: Date? {
        getProperty(id: .editTime)
    }
    
    public var lastPrinted: Date? {
        getProperty(id: .lastPrinted)
    }
    
    public var createDtm: Date? {
        getProperty(id: .createDtm)
    }
    
    public var lastSaveDtm: Date? {
        getProperty(id: .lastSaveDtm)
    }
    
    public var pageCount: Int32? {
        getProperty(id: .pageCount)
    }
    
    public var wordCount: Int32? {
        getProperty(id: .wordCount)
    }
    
    public var charCount: Int32? {
        getProperty(id: .charCount)
    }
    
    public var thumbnail: Double? {
        getProperty(id: .thumbnail)
    }
    
    public var appName: String? {
        getProperty(id: .appName)
    }
    
    public var documentSecurity: DocumentSecurity? {
        guard let rawValue: Int32 = getProperty(id: .docSecurity) else {
            return nil
        }
        
        return DocumentSecurity(rawValue: rawValue)
    }
    
    private func getProperty<T>(id: PropertyId) -> T? {
        return propertySetStream.propertySet0.getProperty(id: id.rawValue)
    }
    
    private enum PropertyId: PropertyIdentifier {
        /// PIDSI_TITLE (0x00000002) VT_LPSTR (0x001E) The title of the document.
        case title = 0x00000002
        
        /// PIDSI_SUBJECT (0x00000003) VT_LPSTR (0x001E) The subject of the document.
        case subject = 0x00000003
        
        /// PIDSI_AUTHOR (0x00000004) VT_LPSTR (0x001E) The author of the document.
        case author = 0x00000004
        
        /// PIDSI_KEYWORDS (0x00000005) VT_LPSTR (0x001E) Keywords related to the document.
        case keywords = 0x00000005
        
        /// PIDSI_COMMENTS (0x00000006) VT_LPSTR (0x001E) Comments related the document.
        case comments = 0x00000006
        
        /// PIDSI_TEMPLATE (0x00000007) VT_LPSTR (0x001E) The application-specific template from which the document was created.
        case template = 0x00000007
        
        /// PIDSI_LASTAUTHOR (0x00000008) VT_LPSTR (0x001E) The last author of the document.
        case lastAuthor = 0x00000008
        
        /// PIDSI_REVNUMBER (0x00000009) VT_LPSTR (0x001E) An application-specific revision number for this version of the document.
        case revNumber = 0x00000009
        
        /// PIDSI_EDITTIME (0x0000000A) VT_FILETIME (0x0040) A 64-bit unsigned integer indicating the total amount of time that has been
        /// spent editing the document in 100-nanosecond increments. MUST be encoded as a FILETIME by setting the dwLowDataTime field
        /// to the low 32-bits and the dwHighDateTime field to the high 32-bits.
        case editTime = 0x0000000A
        
        /// PIDSI_LASTPRINTED (0x0000000B) VT_FILETIME (0x0040) The most recent time that the document was printed.
        case lastPrinted = 0x0000000B
        
        /// PIDSI_CREATE_DTM (0x0000000C) VT_FILETIME (0x0040) The time that the document was created.
        case createDtm = 0x0000000C
        
        /// PIDSI_LASTSAVE_DTM (0x0000000D) VT_FILETIME (0x0040) The most recent time that the document was saved.
        case lastSaveDtm = 0x0000000D
        
        /// PIDSI_PAGECOUNT (0x0000000E) VT_I4 (0x0003) The total number of pages in the document.
        case pageCount = 0x0000000E
        
        /// PIDSI_WORDCOUNT (0x0000000F) VT_I4 (0x0003) The total number of words in the document.
        case wordCount = 0x0000000F
        
        /// PIDSI_CHARCOUNT (0x00000010) VT_I4 (0x0003) The total number of characters in the document.
        case charCount = 0x00000010
        
        /// PIDSI_THUMBNAIL (0x00000011) VT_CF (0x0047) Application-specific clipboard data containing a thumbnail representing the
        /// document's contents. MAY be absent.
        case thumbnail = 0x00000011
        
        /// PIDSI_APPNAME (0x00000012) VT_LPSTR (0x001E) The name of the application that was used to create the document.
        case appName = 0x00000012
        
        /// PIDSI_DOC_SECURITY (0x00000013) VT_I4 (0x0003) A 32-bit signed integer representing a set of application-suggested access control
        /// flags with the following values:
        /// 0x00000001: Password protected
        /// 0x00000002: Read-only recommended
        /// 0x00000004: Read-only enforced
        /// 0x00000008: Locked for annotations
        case docSecurity = 0x00000013
    }
}
