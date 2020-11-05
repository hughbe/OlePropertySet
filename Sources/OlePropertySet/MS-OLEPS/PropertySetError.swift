//
//  PropertySetError.swift
//  
//
//  Created by Hugh Bellamy on 03/11/2020.
//

import WindowsDataTypes

public enum PropertySetError: Error {
    case corrupted
    case invalidFmtid(expected: GUID, actual: GUID)
}
