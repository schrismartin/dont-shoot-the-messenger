import Vapor
import Library
import HTTP
import Foundation

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("/fbwebhook") { request in
    print("get webhook")
    guard let token = request.data["hub.verify_token"]?.string else {
        return "BAD REQUEST"
        throw Abort.badRequest
    }
    guard let res = request.data["hub.challenge"]?.string else {
        return "BAD REQUEST"
        throw Abort.badRequest
    }
    
    if token == "2318934571" {
        print("send response")

        return res
    } else {
        return "Invalid Token"
    }
}

let PAGE_ACCESS_TOKEN = "EAATAd74WSvYBALSBCAokBXjsaI1iLBL5qnZC9EqrupsKkfyluDZAZAoetN6ehZCWwlb4fM2UYXjkWo5xJdSkwn8DttqhobpU32ZBYRUZAgEtETAlI7m5wK31kyG3Px7ISCLDzfn09skTxjc4J9BwU5elSuXnDxZBIiSfIC0Ak2t4QZDZD"

drop.post("fbwebhook") { request in
    print("Start")
    let url = "https://graph.facebook.com/v2.8/me/messages?access_token=" + PAGE_ACCESS_TOKEN
    guard let data = request.body.bytes else {
        return Response(status: .badRequest, body: "Did not receive message with valid body")
    }
    
    // Get entry subarray
    let json: JSON = try JSON(bytes: data)
    
    guard let entryArray = json["entry"]?.array as? [JSON] else {
        return Response(status: .badRequest, body: "Payload lacking an 'entry' field")
    }
    
    let entry: JSON = entryArray[0]
    
    // Get messaging array
    guard let messageArray = entry["messaging"]?.array as? [JSON] else {
        return Response(status: .badRequest, body: "Payload lacking a 'messaging' field")
    }
    
    let messagingJson = messageArray[0]
    
    // Get message object
    guard let messageJson = try messagingJson["message"]?.makeJSON() else {
        return Response(status: .badRequest, body: "Payload lacking a 'message' field")
    }
    
    // Get sender id
    guard let sender = try messagingJson["sender"]?.makeJSON(), let senderId = sender["id"]?.node else {
        return Response(status: .badRequest, body: "Payload lacking a 'sender' field")
    }
    
    // Get message text
    guard let messageText = messageJson["text"]?.node else {
        return Response(status: .badRequest, body: "Payload lacking a 'message' field")
    }
    
    // Create returned payload
    let payload = JSON([
            "message" :
                ["text" : messageText],
            "recipient" :
                ["id" : senderId]
            ])
    
    // Construct return query
    var urlRequest = URLRequest(url: URL(string: url)!)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    urlRequest.httpBody = Data(try payload.makeBytes())
    
    let session = URLSession.shared
    let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
        if let err = error {
            print("We had a problem")
            return
        }
        print(response)
    })
    task.resume()
    
    let response = try Response(status: .ok, json: try JSON(node: Node(["echo":messageText])))
    return response
}

drop.resource("posts", PostController())

drop.run()
