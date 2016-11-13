//
//  SCMMessageHandler.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/12/16.
//
//

import Foundation
import Vapor
import HTTP
import MongoKitten

public class SCMMessageHandler {
    
    var drop: Droplet
    
    public init(app: Droplet) {
        self.drop = app
    }
    
    enum HandlerErrors: Error {
        case entryParseError
    }
    
    public func handle(json: JSON, callback: @escaping (String, SCMIdentifier) -> Void) throws {
        
        if let type = json["object"]?.string, type == "page" {
            
            // Iterate over the entries, they may be batched
            guard let entries = json["entry"]?.array as? [JSON] else {
                print("Entries could not be decoded")
                throw HandlerErrors.entryParseError
            }
            
            for entry in entries {
                guard let _ = entry["id"]?.string,
                    let _ = entry["time"]?.int,
                    let messaging = entry["messaging"]?.array as? [JSON] else {
                        print("Entry could not successfully be parsed")
                        throw HandlerErrors.entryParseError
                }
                
                for event in messaging {
                    if event["message"] != nil {
                        received(event: event, callback: { (message, id) in
                            callback(message, id)
                        })
                    } else {
                        print("Webhook Received Unknown Event: \(event)")
                    }
                }
            }
        }
    }
    
    public func received(event: JSON, callback: (String, SCMIdentifier) -> Void) {
        // Extract Components
        guard let senderId = event["sender"]?["id"]?.string,
//            let recipientId = event["recipient"]?["id"]?.string,
//            let messageTime = event["timestamp"]?.int,
            let message = event["message"] else {
                return
        }
        
        
        if let _ = message["mid"]?.string,
            let text = message["text"]?.string {
            
            let id = SCMIdentifier(string: senderId)
            
            callback(text, id)
            
        } else {
            return
        }
    }
    
    public func sendMessage(toUserWithIdentifier identifier: SCMIdentifier, withMessage message: String) {
        do {
            let messageData = JSON([
                "recipient" : [
                    "id": Node(identifier.string)
                ],
                "message" : [
                    "text" : Node(message)
                ]
                ])
            
            let access_token = drop.config["app", "access-token"]!.string!
            let url = "https://graph.facebook.com/v2.8/me/messages?access_token=" + access_token
            let response = try drop.client.post(url, headers: ["Content-Type": "application/json"], query: [:], body: messageData.makeBody())
            
        } catch {
            print("Unable to post")
            return
        }
    }
}
