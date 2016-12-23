//
//  FBButton.swift
//  the-narrator
//
//  Created by Chris Martin on 11/19/16.
//
//

import Foundation
import MongoKitten
import Vapor
import HTTP

public struct FBButton: FBMessageAttachment {
    
    public enum ButtonType: String {
        case url = "web_url"
        case postback = "postback"
        case share = "element_share"
        case logIn = "account_link"
        case logOut = "account_unlink"
    }
    
    public var buttonType: ButtonType
    public var title: String
    public var payload: String
    
    public init(type: ButtonType = .postback, title: String, payload: String) {
        self.buttonType = type
        self.title = title
        self.payload = payload
    }
}

// Allow the Button to be passed by itself without extranenous logic converting it into JSON
extension FBButton: JSONRepresentable, NodeRepresentable {
    
    public func makeNode(context: Context) throws -> Node {
        return Node([
            "type": Node(buttonType.rawValue),
            "title": Node(title),
            "payload": Node(payload)
        ])
    }
    
}
