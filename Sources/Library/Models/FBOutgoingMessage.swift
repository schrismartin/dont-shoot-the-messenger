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
    
    static let drop = Droplet()
    
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
    public var delay: Double = SCMConfig.sendDelay
    
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

// MARK: Sending Implementation
extension FBOutgoingMessage {
    
    public enum MessageIndicator {
        case typing
        case seen
    }
    
    /// Send the typing indicator to Facebook user in the Messenger context.
    /// - Parameter identifier: Unique identifier constructed with the user's Facebook id
    @discardableResult
    public static func sendIndicator(type: MessageIndicator, to identifier: SCMIdentifier) throws -> Response {
        
        // JSON payload constructing typing message
        var typingData = JSON([
            "recipient" : [
                "id": Node(identifier.string)
            ]
        ])
        
        switch type {
        case .typing:
            typingData["sender_action"] = JSON("typing_on")
        case .seen:
            typingData["sender_action"] = JSON("mark_seen")
        }
        
        // Create destination URL using base and configured Facebook Access Token
        let url = SCMConfig.urlBase + SCMConfig.facebookAccessToken
        return try FBOutgoingMessage.drop.client.post(url, headers: ["Content-Type": "application/json"], query: [:], body: typingData.makeBody())
    }
    
    /// Send JSON-encoded payload to url
    /// - Parameter url: Destination URL
    /// - Parameter payload: JSON data to be sent
    public func send(withResponseHandler handler: ResponseBlock? = nil) {
        
        // Attempt to send the typing indicator
        _ = try? FBOutgoingMessage.sendIndicator(type: .typing, to: recipientId)
        
        // Activate sendMessage(to:withPayload:) asyncronously
        let deadline = DispatchTime.now() + delay
        DispatchQueue.global().asyncAfter(deadline: deadline, execute: {
            let response = try? self.sendMessage()
            
            // Give user optional response
            handler?(response)
        })
    }
    
    /// Send JSON-encoded payload to url
    /// - Parameter url: Destination URL
    /// - Parameter payload: JSON data to be sent
    @discardableResult
    private func sendMessage() throws -> Response {
        do {
            let url = SCMConfig.urlBase + SCMConfig.facebookAccessToken
            let json = try makeJSON()
            
            console.log("Message Sent with JSON: \(json.bodyString)")
            
            return try FBOutgoingMessage.drop.client.post(url, headers: ["Content-Type": "application/json"], query: [:], body: json.makeBody())
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
