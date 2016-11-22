//
//  FBMessage.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/20/16.
//
//

import Foundation
import MongoKitten
import Vapor
import HTTP

public class FBMessage {
    
    public enum URLType {
        case none
        case image
        case video
        case audio
        case file
    }
    
    public enum FBMessageError: Error {
        case noMessage
        case notImplemented
        case tooManyButtons
    }
    
    fileprivate var buttons: [FBButton] = []
    public var recipientId: SCMIdentifier
    public var messageText: String
    public var urlType: URLType = .none
    public var url: URL?
    
    public init(text: String, recipientId: SCMIdentifier) {
        self.messageText = text
        self.recipientId = recipientId
    }
    
    public func addButton(button: FBButton) throws {
        guard buttons.count < 3 else {
            throw FBMessageError.tooManyButtons
        }
        
        buttons.append(button)
    }
    
    public func clearButtons() {
        buttons.removeAll()
    }

}

extension FBMessage: JSONRepresentable, NodeRepresentable {
    
    public func makeNode(context: Context) throws -> Node {
        
        if !buttons.isEmpty {
            return try makeMessage(withAttachment: buttonAttachment)
        }
        
        switch urlType {
        case .none:
            
            if buttons.count != 0 {
                return try makeMessage(withAttachment: buttonAttachment)
            } else {
                return plainMessage
            }
            
        default:
            throw FBMessageError.notImplemented
            
        }
    }
    
    private func makeMessage(withAttachment attachment: Node) throws -> Node {
        return Node([
            "recipient" : [
                "id": Node(recipientId.string)
            ],
            "message": [
                "attachment" : attachment
            ]
        ])
    }
    
    private var plainMessage: Node {
        return Node([
            "recipient" : [
                "id": Node(recipientId.string)
            ],
            "message" : [
                "text" : Node(messageText)
            ]
        ])
    }
    
    private var buttonAttachment: Node {
        let buttonsNode = buttons.flatMap { try? $0.makeNode() }
        
        return Node([
            "type": "template",
            "payload": [
                "template_type": "button",
                "text": Node(messageText),
                "buttons": Node(buttonsNode)
            ]
        ])
    }
}
