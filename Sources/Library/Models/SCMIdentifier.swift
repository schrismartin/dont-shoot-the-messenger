//
//  SCMIdentifier.swift
//  the-narrator
//
//  Created by Chris Martin on 11/13/16.
//
//

import Foundation
import MongoKitten
import Vapor
import HTTP

public struct SCMIdentifier {
    public var string: String
    public var objectId: ObjectId? {
        let hexRepresentation = string.hashValue.hex
        
        do {
            switch hexRepresentation.count {
            case let x where x > 12:
                let str = hexRepresentation.substring(to: hexRepresentation.index(hexRepresentation.startIndex, offsetBy: 12)).toBytes()
                return try ObjectId.init(bytes: str)
            case let x where x == 12:
                let str = hexRepresentation.toBytes()
                return try ObjectId.init(bytes: str)
            case let x where x < 12:
                let str = hexRepresentation.padding(toLength: 12, withPad: "0", startingAt: x).toBytes()
                return try ObjectId.init(bytes: str)
            default:
                assert(false) // There's no case where this would happen
            }
        } catch {
            return nil
        }
        
        return nil
    }
}
