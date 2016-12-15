import Vapor
import Library
import MongoKitten
import HTTP
import Foundation

let drop = Droplet()

drop.get("/fbwebhook") { request in
    console.log("get webhook")
    guard let token = request.data["hub.verify_token"]?.string else {
        throw Abort.badRequest
    }
    guard let res = request.data["hub.challenge"]?.string else {
        throw Abort.badRequest
    }
    
    if token == "2318934571" {
        console.log("send response")
        
        return res
    } else {
        return "Invalid Token"
    }
}

drop.post("fbwebhook") { request in
    
    guard let data = request.body.bytes else {
        // There was no real data
        console.log("Data could not be determined")
        return Response(status: .badRequest, body: "Data could not be determined")
    }
    
    do {
        
        let json = try JSON(bytes: data)
    
        let handler = SCMMessageHandler(app: drop)
        
        try handler.handle(json: json, callback: { (message) in
            let gameManager = SCMGameStateManager(messageHandler: handler)
            try gameManager.handleIncomingMessage(message)
        })
        
    } catch let error {
        console.log("There was an issue handling the request: \(try? data.toString()) - Error: \(error)")
        throw error
    }

    console.log("Request returning successfully")
    return Response(status: .ok)
}

// Do some other stuff
drop.resource("posts", PostController())

// Run it
drop.run()

