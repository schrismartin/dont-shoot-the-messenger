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

public class SCMMessageHandler {
    
    var drop: Droplet
    
    public init(drop: Droplet) {
        self.drop = drop
    }
    
    enum HandlerErrors: Error {
        case entryParseError
    }
    
    public func handle(json: JSON) throws -> [String] {
        var returnedStrings = [String]()
        
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
                        guard let text = received(event: event) else { continue }
                        returnedStrings.append(text)
                    } else {
                        print("Webhook Received Unknown Event: \(event)")
                    }
                }
            }
        }
        
        return returnedStrings
    }
    
    fileprivate func received(event: JSON) -> String? {
        // Extract Components
        guard let senderId = event["sender"]?["id"]?.string,
            let recipientId = event["recipient"]?["id"]?.string,
            let messageTime = event["timestamp"]?.int,
            let message = event["message"] else {
                return nil
        }
        
        print("Received message for user \(senderId) and page \(recipientId) at \(messageTime) for message:")
        
        
        if let messageId = message["mid"]?.string,
            let text = message["text"]?.string {
            print(messageId, text)
            
            sendMessage(to: senderId, withMessage: text)
            return text
        } else {
            return nil
        }
    }
    
    public func sendMessage(to user: String, withMessage message: String) {
        do {
            let messageData = JSON([
                "recipient" : [
                    "id": Node(user)
                ],
                "message" : [
                    "text" : Node(message)
                ]
                ])
            
            let access_token = drop.config["app", "access-token"]!.string!
            let url = "https://graph.facebook.com/v2.8/me/messages?access_token=" + access_token
            let response = try drop.client.post(url, headers: ["Content-Type": "application/json"], query: [:], body: messageData.makeBody())
            
            print(try Data(response.body.bytes!).string())
            
        } catch {
            print("Unable to post")
            return
        }
    }
}
