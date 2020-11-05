//
//  DocumentSecurity.swift
//  
//
//  Created by Hugh Bellamy on 05/11/2020.
//

/// PIDSI_DOC_SECURITY (0x00000013) VT_I4 (0x0003) A 32-bit signed integer representing a set of application-suggested access control
/// flags with the following values:
public struct DocumentSecurity: OptionSet {
    public let rawValue: Int32
    
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    
    /// 0x00000001: Password protected
    public static let passwordProtected = DocumentSecurity(rawValue: 0x00000001)
    
    /// 0x00000002: Read-only recommended
    public static let readOnlyRecommended = DocumentSecurity(rawValue: 0x00000002)
    
    /// 0x00000004: Read-only enforced
    public static let readOnlyEnforced = DocumentSecurity(rawValue: 0x00000004)
    
    /// 0x00000008: Locked for annotations
    public static let lockedForAnnotations = DocumentSecurity(rawValue: 0x00000004)
    
    public static let all: DocumentSecurity = [.passwordProtected, .readOnlyRecommended, .readOnlyEnforced, .lockedForAnnotations]
}
