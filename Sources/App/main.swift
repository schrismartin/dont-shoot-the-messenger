import Vapor
import Library
import HTTP
import Foundation

func buildAreas(){
    //Create all area objects
    let forest = Area()
    let cave = Area()
    let riddleRoom = Area()
    let spiritTree = Area()
    let building = Area()
    let cellar = Area()
    
    //Set paths between areas
    forest.paths.append(spiritTree)
    forest.paths.append(cave)
    forest.paths.append(building)

    building.paths.append(cellar)
    building.paths.append(forest)

    cellar.paths.append(cellar)

    cave.paths.append(riddleRoom)
    cave.paths.append(forest)

    riddleRoom.paths.append(cave)

    //set enter conditions 
    
    //No Forest Enter Conditions
    
    //building
    building.eConditionI = Key(x:1);
    //cave

    //riddleRoom

    //cellar

    //spiritTree




}


let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("/fbwebhook") { request in
    print("get webhook")
    guard let token = request.data["hub.verify_token"]?.string else {
        throw Abort.badRequest
    }
    guard let res = request.data["hub.challenge"]?.string else {
        throw Abort.badRequest
    }
    
    if token == "2318934571" {
        print("send response")

        return res
    } else {
        return "Invalid Token"
    }
}

let PAGE_ACCESS_TOKEN = "EAATAd74WSvYBAFpstWfFB1fp3OJbqhL2lb1MddvxqxoduD23YqgdA1C5VXNKBBFR8qHTIMFcTEkzAqC5bZCLKZBPolvOitVxvqsxX3cHSE0KTF8Mq6URz8i3OdTivk2iQQikk99GTrIir1zvvXasyd9ZA6Y4rMhEPya61TO7QZDZD"

func sendMessage(to user: String, withMessage message: String) {
    do {
        let messageData = JSON([
            "recipient" : [
                "id": Node(user)
                ],
             "message" : [
                "text" : Node(message)
                ]
            ])
        
        let url = "https://graph.facebook.com/v2.8/me/messages?access_token=" + PAGE_ACCESS_TOKEN
        let response = try drop.client.post(url, headers: ["Content-Type": "application/json"], query: [:], body: messageData.makeBody())
        
        print(try Data(response.body.bytes!).string())
    
    } catch {
        print("Unable to post")
        return
    }
}

func received(event: JSON) -> String? {
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

drop.post("fbwebhook") { request in

    guard let data = request.body.bytes else {
        // There was no real data
        print("Data could not be determined")
        return Response(status: .badRequest, body: "Data could not be determined")
    }
    
    let json = try JSON(bytes: data)

    if let type = json["object"]?.string, type == "page" {
        
        // Iterate over the entries, they may be batched
        guard let entries = json["entry"]?.array as? [JSON] else {
            print("Entries could not be decoded")
            return Response(status: .badRequest, body: "Entries could not be decoded")
        }
        
        for entry in entries {
            guard let pageId = entry["id"]?.string,
                let timeOfEvent = entry["time"]?.int,
                let messaging = entry["messaging"]?.array as? [JSON] else {
                    print("Entry could not successfully be parsed")
                    return Response(status: .badRequest, body: "Entry could not successfully be parsed")
            }
            
            for event in messaging {
                if let message = event["message"] {
                    let text = received(event: event)
                    return Response(status: .ok, body: "Webhook Received Text: \(text)")
                } else {
                    print("Webhook Received Unknown Event: \(event)")
                    return Response(status: .ok, body: "Webhook Received Unknown Event: \(event)")
                }
            }
        }
    }
    
    print("Things worked out")
    return Response(status: .ok, body: "Things worked out")
}



drop.resource("posts", PostController())

drop.run()
