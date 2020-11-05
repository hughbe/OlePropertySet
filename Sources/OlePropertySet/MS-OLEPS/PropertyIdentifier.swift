//
//  File.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import Foundation

/// [MS-OLEPS] 2.1 PropertyIdentifier
/// The PropertyIdentifier data type represents the property identifier of a property in a property set.
/// This type is declared as follows:
/// typedef unsigned int PropertyIdentifier;
/// Value Meaning
/// Normal 0x00000002 — 0x7FFFFFFF Used to identify normal properties.
/// DICTIONARY_PROPERTY_IDENTIFIER 0x00000000 property identifier for the Dictionary property.
/// CODEPAGE_PROPERTY_IDENTIFIER 0x00000001 property identifier for the CodePage property.
/// LOCALE_PROPERTY_IDENTIFIER 0x80000000 property identifier for the Locale property.
/// BEHAVIOR_PROPERTY_IDENTIFIER 0x80000003 property identifier for the Behavior property.
public typealias PropertyIdentifier = UInt32

public let DICTIONARY_PROPERTY_IDENTIFIER = 0x00000000
public let CODEPAGE_PROPERTY_IDENTIFIER = 0x00000001
public let LOCALE_PROPERTY_IDENTIFIER = 0x80000000
public let MODIFY_TIME_PROPERTY_IDENTIFIER = 0x80000001
public let SECURITY_PROPERTY_IDENTIFIER = 0x80000002
public let BEHAVIOR_PROPERTY_IDENTIFIER = 0x80000003
