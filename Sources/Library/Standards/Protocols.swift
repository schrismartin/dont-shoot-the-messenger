//
//  Protocols.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/18/16.
//
//

import Foundation
import MongoKitten
import HTTP

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public protocol DatabaseRepresentable {
    
    init(document: Document)
    var document: Document { get }
    
}

public class console {
    public static func log(_ string: String?) {
        fputs("\(string)\n", stdout)
        fflush(stdout)
    }
}

extension Response {
    public var bodyString: String? {
        let data = Data(body.bytes!)
        return try? data.toString()
    }
}
