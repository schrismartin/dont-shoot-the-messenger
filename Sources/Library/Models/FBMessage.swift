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
        case tooManyQuickReplies
    }
    
    fileprivate var buttons: [FBButton] = []
    fileprivate var quickReplies: [FBQuickReply] = []
    public var recipientId: SCMIdentifier
    public var messageText: String
    public var urlType: URLType = .none
    public var url: URL?
    
    public init(text: String, recipientId: SCMIdentifier) {
        self.messageText = text
        self.recipientId = recipientId
    }
    
    public func addButton(button: FBButton) throws {
        
        // Prevent addition of more than 3 buttons
        guard buttons.count < 3 else {
            throw FBMessageError.tooManyButtons
        }
        
        buttons.append(button)
    }
    
    public func clearButtons() {
        buttons.removeAll()
    }
    
    public func addQuickReply(reply: FBQuickReply) throws {
        
        // Prevent addition of more than 11 quick replies
        guard quickReplies.count < 11 else {
            throw FBMessageError.tooManyQuickReplies
        }
        
        quickReplies.append(reply)
    }

}

extension FBMessage: JSONRepresentable, NodeRepresentable {
    
    public func makeNode(context: Context) throws -> Node {
        
        // Construct Base
        var base: [String: Node]
        
        // Determine base JSON payload
        switch urlType {
        case .none:
            
            if buttons.count != 0 {
                base = makeMessage(withAttachment: buttonAttachment)
            } else {
                base = plainMessage
            }
            
        default:
            throw FBMessageError.notImplemented
        }
        
        // Add optional quick replies
        if !quickReplies.isEmpty {
            let quickReplies = self.quickReplies.flatMap { try? $0.makeNode() }
            base["message"]?["quick_replies"] = Node(quickReplies)
        }
        
        return Node(base)
    }
    
    private func makeMessage(withAttachment attachment: [String: Node]) -> [String: Node] {
        return [
            "recipient" : [
                "id": Node(recipientId.string)
            ],
            "message": [
                "attachment" : Node(attachment)
            ]
        ]
    }
    
    private var plainMessage: [String: Node] {
        return [
            "recipient" : [
                "id": Node(recipientId.string)
            ],
            "message" : [
                "text" : Node(messageText)
            ]
        ]
    }
    
    private var buttonAttachment: [String: Node] {
        let buttonsNode = buttons.flatMap { try? $0.makeNode() }
        
        return [
            "type": "template",
            "payload": [
                "template_type": "button",
                "text": Node(messageText),
                "buttons": Node(buttonsNode)
            ]
        ]
    }
}
