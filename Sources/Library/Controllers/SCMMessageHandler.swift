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
    static let urlBase: String = "https://graph.facebook.com/v2.8/me/messages?access_token="
    
    public init(app: Droplet) {
        self.drop = app
    }
    
    enum HandlerErrors: Error {
        case entryParseError
    }
    
    // MARK: Handle Recipient
    
    public func handleAsync(json: JSON, callback: @escaping (FBMessagePayload) throws -> Void) {
        // Run Asyncronously
        DispatchQueue.global().async {
            try! self.handle(json: json, callback: callback)
        }
    }
    
    fileprivate func handle(json: JSON, callback: @escaping (FBMessagePayload) throws -> Void) throws {
        
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
                        try received(event: event, callback: { (payload) in
                            
                            self.sendTypingAsync(toUserWithIdentifier: payload.senderId)
                            
                            try callback(payload)
                        })
                    } else {
                        print("Webhook Received Unknown Event: \(event)")
                    }
                }
            }
        }
    }
    
    fileprivate func received(event: JSON, callback: (FBMessagePayload) throws -> Void) throws {
        // Extract Components
        guard let senderId = event["sender"]?["id"]?.string,
            let recipientId = event["recipient"]?["id"]?.string,
            let messageTime = event["timestamp"]?.int,
            let message = event["message"] else {
                return
        }
        
        
        if let _ = message["mid"]?.string,
            let text = message["text"]?.string {
            
            let returnedSenderId = SCMIdentifier(string: senderId)
            let returnedRecipientId = SCMIdentifier(string: recipientId)
            let returnedTime = Date(timeIntervalSince1970: TimeInterval(messageTime))
            let payload = FBMessagePayload(senderId: returnedSenderId, recipientId: returnedRecipientId, date: returnedTime, message: text)
            
            try callback(payload)
            
        } else {
            return
        }
    }
    
    // MARK: Send Message
    
    public func sendMessageAsync(toUserWithIdentifier identifier: SCMIdentifier, withMessage message: String) {
        DispatchQueue.global().async {
            self.sendMessage(toUserWithIdentifier: identifier, withMessage: message)
        }
    }
    
    fileprivate func sendMessage(toUserWithIdentifier identifier: SCMIdentifier, withMessage message: String) {
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
            print(try? response.body.bytes!.toString() ?? "nil")
            
        } catch {
            print("Unable to post")
        }
    }
    
    // MARK: Show Typing
    
    public func sendTypingAsync(toUserWithIdentifier identifier: SCMIdentifier) {
        DispatchQueue.global().async {
            self.sendTyping(toUserWithIdentifier: identifier)
        }
    }
    
    fileprivate func sendTyping(toUserWithIdentifier identifier: SCMIdentifier) {
        do {
            let messageData = JSON([
                "recipient" : [
                    "id": Node(identifier.string)
                ],
                "sender_action" : "typing_on"
                ])
            
            let access_token = drop.config["app", "access-token"]!.string!
            let url = SCMMessageHandler.urlBase + access_token
            let response = try drop.client.post(url, headers: ["Content-Type": "application/json"], query: [:], body: messageData.makeBody())
            print(try? response.body.bytes!.toString() ?? "nil")
            
        } catch {
            print("Unable to post")
        }
    }
}


//Chris Nagy's Code Start

//If the actions was recognized, call that actions function and return true; else return false
func findAction(index: Int, parsedText: [String],player: Player, area: Area) -> Bool{
    switch parsedText[index] {
        case "use":
            use(index: index,parsedText: parsedText,player: player, area: area)
            return true
        case "go":
            go(index: index,parsedText: parsedText,player: player, area: area)
            return true
        case "pickup":
            pickUp(index: index,parsedText: parsedText,player: player, area: area)
            return true
        case "look":
            look(index: index,parsedText: parsedText,player: player, area: area)
            return true
        case "inventory":
            inventory(index: index,parsedText: parsedText,player: player, area: area)
            return true
        default:
            return false
    }
}
//print player inventory 
func inventory(index: Int, parsedText: [String],player: Player, area: Area) {
    print("Inventory:\n")
    for i in player.inventory {
        print ("\(i.quantity)  \(i.name)(s) ")
    }
}

//attempt to combine two items
func use(index: Int, parsedText: [String],player: Player, area: Area) {
    //check player inventory
    for i in index..<parsedText.count{
        print("\(i) = \(parsedText[i])")
        for j in 0..<player.inventory.count{
            //check if the first item is in inventory
            if (parsedText[i] == player.inventory.array[j].name && player.inventory.array[j].quantity > 0){
                //find second item in parsedText   
                for i in i..<parsedText.count{
                //check if the second item is viable to use with the first item 
                    //for k
                    //if (parsedText[i] == player.inventory.array[j].keywords)
                }
                //and that it is in the players inventory

            }
        }
    }
    print("You can't do that.\n")
}

//Pickup
func pickUp(index: Int, parsedText: [String],player: Player, area: Area) {
    //check environment inventory
}



//Go 
func go(index: Int, parsedText: [String],player: Player, area: Area) {
    //check Area paths
}




//Look
func look(index: Int, parsedText: [String],player: Player, area: Area) {
    //area or player inventory
}












