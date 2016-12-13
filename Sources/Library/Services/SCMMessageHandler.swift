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
    fileprivate var drop: Droplet
    fileprivate let messageSendQueue = DispatchQueue(label: "MessageSendQueue")
    
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
    public func handleAsync(json: JSON, callback: @escaping (FBIncomingMessage) throws -> Void) {
        // Run Asyncronously
        DispatchQueue(label: "Handler").async {
            do { try self.handle(json: json, callback: callback) } catch {
                console.log("Issue encountered in handling: \(error)")
            }
        }
    }
    
    /// Handle an incoming Messenger JSON Payload and delegate the handling of resulting events.
    /// - Parameter json: JSON payload containing all data returned by a Facebook message
    /// - Parameter callback: Closure containing all game logic.
    fileprivate func handle(json: JSON, callback: @escaping (FBIncomingMessage) throws -> Void) throws {
        
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
        for data in events {
            
            // Extract payload
            guard let event = try? extractEvent(from: data) else { continue }
            
            // User feedback
            self.sendTypingIndicatorAsync(toUserWithIdentifier: event.senderId)
            try callback(event)
            
        }
    }
    
    /// Constructs an expected Facebook Messenger event from the received JSON data
    /// - Parameter event: The JSON payload representation of an event
    fileprivate func extractEvent(from payload: JSON) throws -> FBIncomingMessage {
        
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
            let returned = FBIncomingMessage(senderId: returnedSenderId, recipientId: returnedRecipientId,
                                         date: returnedTime, text: text, postback: nil)
            return returned
        }
        
        // Postback Branch
        if let postback = payload["postback"], let payload = postback["payload"]?.string {
            let returned = FBIncomingMessage(senderId: returnedSenderId, recipientId: returnedRecipientId,
                                          date: returnedTime, text: nil, postback: payload)
            return returned
        }
        
        // Should reach one of those two events, throw an error if it gets here.
        console.log("Unrecognized event received: \(payload.bodyString)")
        throw HandlerErrors.unexpectedEventFormat
    }
}

// MARK: Utility Constructs
extension SCMMessageHandler {
    /// Closure for use with asyncronous network requests.
    /// - Parameter response: Response from the asyncronous request. `nil` if request failed altogether.
    public typealias ResponseBlock = (Response?) -> (Void)
}

// MARK: Show Typing
extension SCMMessageHandler {
    
    /// Send the typing indicator to Facebook user in the Messenger context.
    /// - Parameter identifier: Unique identifier constructed with the user's Facebook id
    /// - Parameter handler: Optional handler of HTTP response
    public func sendTypingIndicatorAsync(toUserWithIdentifier identifier: SCMIdentifier,
                                withResponseHandler handler: ResponseBlock? = nil) {
        
        // Activate sendTyping(toUserWithIdentifier:) asyncronously
        messageSendQueue.async {
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
        let url = SCMMessageHandler.urlBase + SCMConfig.facebookAccessToken
        return try sendMessage(to: url, withPayload: typingData)
    }
}

// MARK: Message Sending Functions
extension SCMMessageHandler {
    
    /// Send JSON-encoded payload to url
    /// - Parameter url: Destination URL
    /// - Parameter payload: JSON data to be sent
    public func sendMessage(_ message: FBOutgoingMessage, withResponseHandler handler: ResponseBlock? = nil) {
        let url = SCMMessageHandler.urlBase + SCMConfig.facebookAccessToken
        
        // Activate sendMessage(to:withPayload:) asyncronously
        messageSendQueue.async {
            let response = try? self.sendMessage(to: url, withPayload: message)
            
            // Give user optional response
            handler?(response)
        }
    }
    
    /// Send JSON-encoded payload to url
    /// - Parameter url: Destination URL
    /// - Parameter payload: JSON data to be sent
    @discardableResult
    fileprivate func sendMessage(to url: String, withPayload payload: JSONRepresentable) throws -> Response {
        let json = try payload.makeJSON()
        
        console.log("Message Sent with JSON: \(json.bodyString)")
        
        return try drop.client.post(url, headers: ["Content-Type": "application/json"], query: [:], body: json.makeBody())
    }
    
    public func sendGroupedMessages(_ messages: [FBOutgoingMessage]) {
        guard let userIdentifier = messages.first?.recipientId else { return }
        sendTypingIndicatorAsync(toUserWithIdentifier: userIdentifier)
        
        let url = SCMMessageHandler.urlBase + SCMConfig.facebookAccessToken
        var executeTime: DispatchTime = .now()
        
        for message in messages {
            let sendDelay = getMessageSendDelay(for: message)
            
            messageSendQueue.asyncAfter(deadline: executeTime, execute: {
                do { try self.sendMessage(to: url, withPayload: message) }
                catch { console.log("We could not send a message in a group") }
                
                if let lastMessage = messages.last, lastMessage != message  {
                    self.sendTypingIndicatorAsync(toUserWithIdentifier: userIdentifier)
                }
                
            })
            
            executeTime = executeTime + sendDelay + 3
            
        }
    }

}

// MARK: Utility Functions
extension SCMMessageHandler {
    
    fileprivate func getMessageSendDelay(for message: FBOutgoingMessage) -> Double {
        
        let charactersPerSecond: Double = 24
        let messageLength = Double(message.messageText.characters.count)
        
        return messageLength / charactersPerSecond
        
    }
    
}












