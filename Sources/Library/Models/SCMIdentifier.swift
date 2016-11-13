//
//  SCMIdentifier.swift
//  dont-shoot-the-messenger
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
        let str = string.substring(to: string.index(string.startIndex, offsetBy: 12)).toBytes()
        do {
            let objId = try ObjectId.init(bytes: str)
            return objId
        } catch { return nil }
    }
}
