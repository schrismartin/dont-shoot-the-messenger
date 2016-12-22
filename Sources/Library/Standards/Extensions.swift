//
//  Extensions.swift
//  the-narrator
//
//  Created by Chris Martin on 12/21/16.
//
//

import Foundation
import MongoKitten
import HTTP
import JSON

extension Response {
    public var bodyString: String? {
        let data = Data(body.bytes!)
        return try? data.toString()
    }
}

extension JSON {
    public var bodyString: String? {
        let data = Data(makeBody().bytes!)
        return try? data.toString()
    }
}

extension String {
    public static var empty: String {
        return ""
    }
}
