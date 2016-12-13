//
//  FBOutgoingMessage.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/20/16.
//
//

import Foundation
import MongoKitten
import Vapor
import HTTP

public class FBOutgoingMessage {
    
    public enum URLType {
        case none
        case image
        case video
        case audio
        case file
    }
    
    public enum FBOutgoingMessageError: Error {
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
            throw FBOutgoingMessageError.tooManyButtons
        }
        
        buttons.append(button)
    }
    
    public func clearButtons() {
        buttons.removeAll()
    }
    
    public func addQuickReply(reply: FBQuickReply) throws {
        
        // Prevent addition of more than 11 quick replies
        guard quickReplies.count < 11 else {
            throw FBOutgoingMessageError.tooManyQuickReplies
        }
        
        quickReplies.append(reply)
    }

}

extension FBOutgoingMessage: Hashable, Equatable {
    
    public var hashValue: Int {
        // TODO: Make actual hashvalue
        return recipientId.string.hashValue ^ messageText.hashValue
    }
    
    static public func ==(lhs: FBOutgoingMessage, rhs: FBOutgoingMessage) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}

extension FBOutgoingMessage: JSONRepresentable, NodeRepresentable {
    
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
            throw FBOutgoingMessageError.notImplemented
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
