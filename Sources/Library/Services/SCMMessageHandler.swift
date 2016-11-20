//
//  SCMMessageHandler.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/12/16.
//
//

import Foundation
import Dispatch
import Vapor
import HTTP
import MongoKitten

public class SCMMessageHandler {
    
    // Constants
    static let urlBase: String = "https://graph.facebook.com/v2.8/me/messages?access_token="
    
    // Properties
    var drop: Droplet
    
    public init(app: Droplet) {
        self.drop = app
    }
    
    enum HandlerErrors: Error {
        case entryParseError
        case unexpectedEventFormat
    }
}

// MARK: Handle Recipt
extension SCMMessageHandler {
    
    /// Handle an incoming Messenger JSON Payload and delegate the handling of resulting events asyncronously.
    /// - Parameter json: JSON payload containing all data returned by a Facebook message
    /// - Parameter callback: Closure containing all game logic.
    public func handleAsync(json: JSON, callback: @escaping (FBMessageEvent) throws -> Void) {
        // Run Asyncronously
        DispatchQueue.global().async {
            do { try self.handle(json: json, callback: callback) } catch {
                fatalError("Must be implemented")
            }
        }
    }
    
    /// Handle an incoming Messenger JSON Payload and delegate the handling of resulting events.
    /// - Parameter json: JSON payload containing all data returned by a Facebook message
    /// - Parameter callback: Closure containing all game logic.
    fileprivate func handle(json: JSON, callback: @escaping (FBMessageEvent) throws -> Void) throws {
        
        // Print JSON output
        let output = try! Data(json.makeBody().bytes!).toString()
        console.log(output)
        
        // Extract top-level components
        guard let type = json["object"]?.string, type == "page",
            let entries = json["entry"]?.array as? [JSON] else {
            throw HandlerErrors.unexpectedEventFormat
        }
        
        // Extract all events in all messaging arrays into one JSON array
        let events = entries
            .flatMap { $0["messaging"]?.array as? [JSON] }
            .flatMap { $0 }
        
        // Traverse each event and activate callback handler for each
        for data in events where data["message"] != nil {
            
            // Extract payload
            let payload = try extractEvent(from: data)
            
            // User feedback
            self.sendTypingIndicatorAsync(toUserWithIdentifier: payload.senderId)
            try callback(payload)
            
        }
    }
    
    /// Constructs an expected Facebook Messenger event from the received JSON data
    /// - Parameter event: The JSON payload representation of an event
    fileprivate func extractEvent(from payload: JSON) throws -> FBMessageEvent {
        
        // Extract Components
        guard let senderId = payload["sender"]?["id"]?.string,
            let recipientId = payload["recipient"]?["id"]?.string,
            let messageTime = payload["timestamp"]?.int else {
                throw HandlerErrors.unexpectedEventFormat
        }
        
        // Construct Payload
        let returnedSenderId = SCMIdentifier(string: senderId)
        let returnedRecipientId = SCMIdentifier(string: recipientId)
        let returnedTime = Date(timeIntervalSince1970: TimeInterval(messageTime))
        
        // Message Branch
        if let message = payload["message"], let text = message["text"]?.string {
            let returned = FBMessageEvent(senderId: returnedSenderId, recipientId: returnedRecipientId,
                                         date: returnedTime, message: text, postback: nil)
            return returned
        }
        
        // Postback Branch
        if let postback = payload["message"], let payload = postback["text"]?.string {
            let returned = FBMessageEvent(senderId: returnedSenderId, recipientId: returnedRecipientId,
                                         date: returnedTime, message: nil, postback: payload)
            return returned
        }
        
        // Should reach one of those two events, throw an error if it gets here.
        throw HandlerErrors.unexpectedEventFormat
    }
}

// MARK: Utility Constructs
extension SCMMessageHandler {
    /// Closure for use with asyncronous network requests.
    /// - Parameter response: Response from the asyncronous request. `nil` if request failed altogether.
    public typealias ResponseBlock = (Response?) -> Void
}

// MARK: Send Messages
extension SCMMessageHandler {

    /// Send a plaintext message to Facebook user in the Messenger context asyncronously.
    /// - Parameter identifier: Unique identifier constructed with the user's Facebook id
    /// - Parameter message: Plaintext message to be sent to the user
    /// - Parameter handler: Optional handler of HTTP response
    public func sendTextMessageAsync(toUserWithIdentifier identifier: SCMIdentifier,
                                 withMessage message: String,
                                 withResponseHandler handler: ResponseBlock? = nil) {
        
        // Activate sendMessage(toUserWithIdentifier:withMessage:) asyncronously
        DispatchQueue.global().async {
            let response = try? self.sendTextMessage(toUserWithIdentifier: identifier, withMessage: message)
            
            // Give user optional response
            handler?(response)
        }
    }
    
    /// Send a plaintext message to Facebook user in the Messenger context.
    /// - Parameter identifier: Unique identifier constructed with the user's Facebook id
    /// - Parameter message: Plaintext message to be sent to the user
    fileprivate func sendTextMessage(toUserWithIdentifier identifier: SCMIdentifier, withMessage message: String) throws -> Response {
        
        // JSON payload constructing message to be sent
        let messageData = JSON([
            "recipient" : [
                "id": Node(identifier.string)
            ],
            "message" : [
                "text" : Node(message)
            ]
        ])
        
        // Create destination URL using base and configured Facebook Access Token
        let url = SCMMessageHandler.urlBase + ConfigService.shared.facebookAccessToken
        return try sendJson(to: url, withPayload: messageData)
    }
}

// MARK: Show Typing
extension SCMMessageHandler {
    
    /// Send the typing indicator to Facebook user in the Messenger context.
    /// - Parameter identifier: Unique identifier constructed with the user's Facebook id
    /// - Parameter handler: Optional handler of HTTP response
    public func sendTypingIndicatorAsync(toUserWithIdentifier identifier: SCMIdentifier,
                                withResponseHandler handler: ResponseBlock? = nil) {
        
        // Activate sendTyping(toUserWithIdentifier:) asyncronously
        DispatchQueue.global().async {
            let response = try? self.sendTypingIndicator(toUserWithIdentifier: identifier)
            
            // Give user optional response
            handler?(response)
        }
    }
    
    /// Send the typing indicator to Facebook user in the Messenger context.
    /// - Parameter identifier: Unique identifier constructed with the user's Facebook id
    fileprivate func sendTypingIndicator(toUserWithIdentifier identifier: SCMIdentifier) throws -> Response {
        
        // JSON payload constructing typing message
        let typingData = JSON([
            "recipient" : [
                "id": Node(identifier.string)
            ],
            "sender_action" : "typing_on"
            ])
        
        // Create destination URL using base and configured Facebook Access Token
        let url = SCMMessageHandler.urlBase + ConfigService.shared.facebookAccessToken
        return try sendJson(to: url, withPayload: typingData)
    }
}

// MARK: Show Typing
extension SCMMessageHandler {
    
    /// Send the typing indicator to Facebook user in the Messenger context.
    /// - Parameter identifier: Unique identifier constructed with the user's Facebook id
    /// - Parameter handler: Optional handler of HTTP response
    public func sendMessageWithButtonsAsync(toUserWithIdentifier identifier: SCMIdentifier,
                                            withMessage message: String,
                                            withButtons buttons: [FBButton],
                                            withResponseHandler handler: ResponseBlock? = nil) {
        
        // Activate sendTyping(toUserWithIdentifier:) asyncronously
        DispatchQueue.global().async {
            let response = try? self.sendMessageWithButtons(toUserWithIdentifier: identifier,
                                                            withMessage: message,
                                                            withButtons: buttons)
            
            // Give user optional response
            handler?(response)
        }
    }
    
    /// Send the typing indicator to Facebook user in the Messenger context.
    /// - Parameter identifier: Unique identifier constructed with the user's Facebook id
    fileprivate func sendMessageWithButtons(toUserWithIdentifier identifier: SCMIdentifier,
                                            withMessage message: String,
                                            withButtons buttons: [FBButton]) throws -> Response {
        
        // Convert buttons to nodes
        let buttonNodes = buttons.flatMap { try? $0.makeNode() }
        
        // JSON payload constructing typing message
        let buttonData = JSON([
            "recipient" : [
                "id": Node(identifier.string)
            ],
            "message" : [
                "attachment" : [
                    "type": "template",
                    "payload": [
                        "template_type":"button",
                        "text": Node(message),
                        "buttons": Node(buttonNodes)
                    ]
                ]
            ]
        ])
        
        // Create destination URL using base and configured Facebook Access Token
        let url = SCMMessageHandler.urlBase + ConfigService.shared.facebookAccessToken
        return try sendJson(to: url, withPayload: buttonData)
    }
}

// MARK: Helper Functions
extension SCMMessageHandler {
    
    /// Send JSON-encoded payload to url
    /// - Parameter url: Destination URL
    /// - Parameter payload: JSON data to be sent
    fileprivate func sendJson(to url: String, withPayload payload: JSON) throws -> Response {
        return try drop.client.post(url, headers: ["Content-Type": "application/json"], query: [:], body: payload.makeBody())
    }

}












