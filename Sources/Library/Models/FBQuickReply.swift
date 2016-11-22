//
//  FBQuickReply.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/21/16.
//
//

import Foundation
import MongoKitten
import Vapor
import HTTP

public struct FBQuickReply {
    
    public var title: String
    public var imageUrl: URL?
    public var payload: String
    
    public init(title: String, payload: String = "DEFAULT") {
        self.title = title
        self.payload = payload
    }
}

// Allow the Button to be passed by itself without extranenous logic converting it into JSON
extension FBQuickReply: JSONRepresentable, NodeRepresentable {
    
    public func makeNode(context: Context) throws -> Node {
        
        var collection = [
            "content_type": "text",
            "title": Node(title),
            "payload": Node(payload)
        ]
        
        if let url = imageUrl {
            collection["image_url"] = Node(url.absoluteString)
        }
        
        return Node(collection)
    }
    
}
