//
//  Protocols.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/18/16.
//
//

import Foundation
import MongoKitten

public protocol DatabaseRepresentable {
    
    init(document: Document)
    var document: Document { get }
    
}
