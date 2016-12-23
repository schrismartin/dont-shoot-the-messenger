//
//  Protocols.swift
//  the-narrator
//
//  Created by Chris Martin on 11/18/16.
//
//

import Foundation
import MongoKitten
import HTTP
import JSON

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public protocol DatabaseRepresentable {
    
    init(document: Document)
    var document: Document { get }
    
}

public protocol FBMessageAttachment: JSONRepresentable, NodeRepresentable {
    var title: String { get set }
    var payload: String { get set }
}

public class console {
    public static func log(_ string: String) {
        fputs("\(string)\n", stdout)
        fflush(stdout)
    }
}
