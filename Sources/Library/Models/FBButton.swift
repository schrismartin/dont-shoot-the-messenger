//
//  FBButton.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/19/16.
//
//

import Foundation
import MongoKitten
import Vapor
import HTTP

public struct FBButton {
    
    public enum ButtonType: String {
        case postback = "postback"
        case webURL = "web_url"
    }
    
    public var type: ButtonType
    public var title: String
    public var payload: String
    
    public init(type: ButtonType, title: String, payload: String) {
        self.type = type
        self.title = title
        self.payload = payload
    }
}

// Allow the Button to be passed by itself without extranenous logic converting it into JSON
extension FBButton: JSONRepresentable, NodeRepresentable {
    
    public func makeNode(context: Context) throws -> Node {
        return Node([
            "type": Node(type.rawValue),
            "title": Node(title),
            "payload": Node(payload)
        ])
    }
    
}
