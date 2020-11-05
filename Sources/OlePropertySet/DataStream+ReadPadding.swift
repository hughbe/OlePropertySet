//
//  DataStream.swift
//  
//
//  Created by Hugh Bellamy on 05/11/2020.
//

import DataStream

internal extension DataStream {
    mutating func readPadding(fromStart startPosition: Int) throws {
        let excessBytes = (self.position - startPosition) % 4
        if excessBytes != 0 {
            let newPostion = self.position + (4 - excessBytes)
            if newPostion > self.count {
                throw PropertySetError.corrupted
            }
            
            self.position = newPostion
        }
    }
}
