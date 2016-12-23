//
//  SCMMessageHandler.swift
//  the-narrator
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
    
    // Properties
    fileprivate var drop: Droplet
    fileprivate let messageSendQueue = DispatchQueue(label: "MessageSendQueue")
    
    public init(app: Droplet? = nil) {
        self.drop = app ?? Droplet()
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
    @available(*, deprecated)
    public func handleAsync(json: JSON, callback: @escaping (FBIncomingMessage) throws -> Void) {
        // Run Asyncronously
        DispatchQueue(label: "Handler").async {
            do { try self.handle(json: json, callback: callback) } catch {
                console.log("Issue encountered in handling. Error: \(error)")
            }
        }
    }
    
    /// Handle an incoming Messenger JSON Payload and delegate the handling of resulting events.
    /// - Parameter json: JSON payload containing all data returned by a Facebook message
    /// - Parameter callback: Closure containing all game logic.
    public func handle(json: JSON, callback: @escaping (FBIncomingMessage) throws -> Void) throws {
        
        // Print JSON output
        if let output = try? Data(json.makeBody().bytes!).toString() {
            console.log(output)
        }
        
        // Extract top-level components
        guard let type = json["object"]?.string, type == "page",
            let entries = json["entry"]?.array as? [JSON] else {
                throw Abort.custom(status: .badRequest, message: "Unexpected Message Entry")
        }
        
        // Extract all events in all messaging arrays into one JSON array
        let events = entries
            .flatMap { $0["messaging"]?.array as? [JSON] }
            .flatMap { $0 }
        
        // Traverse each event and activate callback handler for each
        for data in events {
            
            // Extract payload, skip if failure
            guard let event = FBIncomingMessage(json: data) else { continue }
            
            // User feedback
            _ = try? FBOutgoingMessage.sendIndicator(type: .seen, to: event.recipientId)
            try callback(event)
        }
    }
}

// MARK: Message Sending Functions
extension SCMMessageHandler {
    
    /// Send a group of messages to the user at a delay, where the last message is able to be read
    /// by the time the next one sends
    /// - Parameter messages: Array of messages to be sent
    public func sendGroupedMessages(_ messages: [FBOutgoingMessage]) {
        
        // Send with delays
        var sendDelay: Double = 0
        
        for message in messages {
            
            // Apply delay and send messages
            message.delay = sendDelay
            message.send(handler: { (response) -> (Void) in
                print(response ?? "No response was received from message sent in grouped message")
            })
            
            sendDelay += getMessageSendDelay(for: message) + 2
            
        }
    }

}

// MARK: Utility Functions
extension SCMMessageHandler {
    
    /// Calculate the time it takes to read a message
    /// - Parameter message: FBOutgoing with message to determine the time for
    fileprivate func getMessageSendDelay(for message: FBOutgoingMessage) -> Double {
        
        let charactersPerSecond: Double = 24
        let messageLength = Double(message.messageText.characters.count)
        
        return messageLength / charactersPerSecond
        
    }
    
}
