//
//  FBOutgoingMessage.swift
//  the-narrator
//
//  Created by Chris Martin on 11/20/16.
//
//

import Foundation
import Dispatch
import MongoKitten
import Vapor
import HTTP

public class FBOutgoingMessage {
    
    fileprivate static let drop = Droplet()
    public static let maxButtons = 3
    public static let maxQuickReplies = 11
    
    public enum MessageError: Error {
        case noMessage
        case notImplemented
        case tooManyButtons
        case tooManyQuickReplies
    }
    
    fileprivate var buttons = FixedCapacityArray<FBButton>(capacity: FBOutgoingMessage.maxButtons)
    fileprivate var quickReplies = FixedCapacityArray<FBQuickReply>(capacity: FBOutgoingMessage.maxQuickReplies)
    public var recipientId: SCMIdentifier
    public var messageText: String
    public var delay: Double = SCMConfig.sendDelay
    
    public init(text: String, recipientId: SCMIdentifier) {
        self.messageText = text
        self.recipientId = recipientId
    }
    
    public func addAttachment(attachment: FBMessageAttachment) throws {
        if let button = attachment as? FBButton {
            try buttons.append(button)
        }

        if let quickReply = attachment as? FBQuickReply {
            try quickReplies.append(quickReply)
        }
    }
    
    public func clearButtons() {
        buttons.removeAll()
    }

}

// MARK: Sending Implementation
extension FBOutgoingMessage {
    
    public enum MessageIndicator {
        case typing
        case seen
    }
    
    /// Send off the attached json payload.
    /// - Parameter json: Payload to be sent
    private static func send(json: JSON) throws -> Response {
        let url = SCMConfig.urlBase + SCMConfig.facebookAccessToken
        return try drop.client.post(url, headers: ["Content-Type": "application/json"], query: [:], body: json.makeBody())
    }
    
    /// Send the typing indicator to Facebook user in the Messenger context.
    /// - Parameter identifier: Unique identifier constructed with the user's Facebook id
    @discardableResult
    public static func sendIndicator(type: MessageIndicator, to identifier: SCMIdentifier) throws -> Response {
        
        // JSON payload constructing typing message
        var typingData = FBOutgoingMessage.messageBase(recipientId: identifier)
        
        switch type {
        case .typing:
            typingData["sender_action"] = Node("typing_on")
        case .seen:
            typingData["sender_action"] = Node("mark_seen")
        }
        
        let json = JSON(Node(typingData))
        return try FBOutgoingMessage.send(json: json)
    }
    
    @discardableResult
    public static func notify(user recipientId: SCMIdentifier, of error: Error) throws -> Response? {
        let message = FBOutgoingMessage(text: "We've encountered an error: \(error). Please post about this on our Facebook page! In the meantime, you can hang tight and we'll try to fix it, or you can restart the game.", recipientId: recipientId)
        return try message.sendMessage()
    }
    
    /// Send the message to the messenger endpoint
    /// - Parameter handler: Optional closure handling the response message
    public func send(handler: ResponseBlock? = nil) {
        
        // Attempt to send the failable typing indicator
        _ = try? FBOutgoingMessage.sendIndicator(type: .typing, to: recipientId)
        
        // Activate sendMessage() after time interval
        let deadline = DispatchTime.now() + delay
        DispatchQueue.global().asyncAfter(deadline: deadline, execute: {
            let response = try? self.sendMessage()
            
            // Give user optional response
            handler?(response)
        })
    }
    
    /// Send the message to the messenger endpoint
    @discardableResult
    private func sendMessage() throws -> Response {
        do {
            let json = try makeJSON()
            
            console.log("Message Sent with JSON: \(json.bodyString)")
            
            return try FBOutgoingMessage.send(json: json)
        } catch {
            throw Abort.badRequest
        }
    }
}

// MARK: Hashable, Equatable Conformance
extension FBOutgoingMessage: Hashable, Equatable {
    
    public var hashValue: Int {
        // TODO: Make actual hashvalue
        return recipientId.string.hashValue ^ messageText.hashValue
    }
    
    static public func ==(lhs: FBOutgoingMessage, rhs: FBOutgoingMessage) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}

// MARK: JSON Representations
extension FBOutgoingMessage: JSONRepresentable, NodeRepresentable {
    
    public func makeNode(context: Context) throws -> Node {
        
        // Construct Base
        var base: [String: Node]
        
        // Make plain message or with buttons
        base = buttons.isEmpty
            ? makePlainMessage()
            : makeMessage(withAttachment: buttonAttachment)
        
        // Add optional quick replies
        if !quickReplies.isEmpty {
            let quickReplies = self.quickReplies.items.flatMap { try? $0.makeNode() }
            base["message"]?["quick_replies"] = Node(quickReplies)
        }
        
        return Node(base)
    }
    
    fileprivate static func messageBase(recipientId: SCMIdentifier) -> [String: Node] {
        return [
            "recipient" : [
                "id": Node(recipientId.string)
            ]
        ]
    }
    
    private func makePlainMessage() -> [String: Node] {
        var message = FBOutgoingMessage.messageBase(recipientId: recipientId)
        message["message"] = [
            "text" : Node(messageText)
        ]
        return message
    }
    
    private func makeMessage(withAttachment attachment: [String: Node]) -> [String: Node] {
        var message = FBOutgoingMessage.messageBase(recipientId: recipientId)
        message["message"] =  [
            "attachment" : Node(attachment)
        ]
        return message
    }
    
    private var buttonAttachment: [String: Node] {
        let buttonsNode = buttons.items.flatMap { try? $0.makeNode() }
        
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
