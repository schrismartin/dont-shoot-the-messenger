//
//  main.swift
//  the-narrator
//
//  Created by Chris Martin on 11/21/16.
//
//

import Vapor
import Library
import MongoKitten
import HTTP
import Foundation

let drop = Droplet()

drop.get("/") { request in
    return "You've reached the homepage for \"The Narrator\"."
}

drop.get("/fbwebhook") { request in
    console.log("get webhook")

    guard let token = request.data["hub.verify_token"]?.string else {
        throw Abort.badRequest
    }
    guard let res = request.data["hub.challenge"]?.string else {
        throw Abort.badRequest
    }
    
    if token == SCMConfig.facebookWebhookKey {
        console.log("send response")
        
        return res
    } else {
        return "Invalid Token"
    }
}

drop.post("/fbwebhook") { request in
    
    guard let data = request.body.bytes else {
        // There was no real data
        console.log("Data could not be determined")
        return Response(status: .badRequest, body: "Data could not be determined")
    }
    
    do {
        
        let json = try JSON(bytes: data)
    
        let handler = SCMMessageHandler(app: drop)
        
        try handler.handle(json: json, callback: { (message) in
            let gameManager = SCMGameStateManager()
            
            do { try gameManager.handleIncomingMessage(message) }
            catch {
                // Notify user of error
                let recipient = message.recipientId
                let response = try? FBOutgoingMessage.notify(user: recipient, of: error)
                console.log("Response for user error message: \(response)")
            }
        })
        
    } catch let error {
        console.log("There was an issue handling the request: \(try? data.toString()) - Error: \(error)")
        throw error
    }

    console.log("Request returning successfully")
    return Response(status: .ok, body: "Message Received\n")
}

// Do some other stuff
drop.resource("posts", PostController())

// Run it
drop.run()

