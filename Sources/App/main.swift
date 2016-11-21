import Vapor
import Library
import MongoKitten
import HTTP
import Foundation

func buildAreas(using manager: SCMDatabaseManager) -> Area? {
    //Create all area objects
    let forest = Area()
    let cave = Area()
    let riddleRoom = Area()
    let spiritTree = Area()
    let building = Area()
    let cellar = Area()
    
    //Set names
    forest.name = "The Forest"
    cave.name = "The Dark Cavern"
    riddleRoom.name = "The Chamber of the Riddle Master"
    spiritTree.name = "The Sacred Grove"
    building.name = "Old Shack"
    cellar.name = "The Dank Cellar"

    //Set paths between areas
    forest.paths.insert(spiritTree.id)
    forest.paths.insert(cave.id)
    forest.paths.insert(building.id)

    building.paths.insert(cellar.id)
    building.paths.insert(forest.id)

    cellar.paths.insert(cellar.id)

    cave.paths.insert(riddleRoom.id)
    cave.paths.insert(forest.id)

    riddleRoom.paths.insert(cave.id)

    /*---set enter conditions---*/
    //No Forest Enter Conditions
    
    //building
    building.eConditionI = Key(quantity: 1);
    //cave
    cave.eConditionI = LitTorch(quantity: 1)
    //riddleRoom
    riddleRoom.eConditionW = "franky"
    //cellar
    cellar.eConditionE = Stick(quantity: 5)
    //spiritTree
    spiritTree.eConditionI = Map(quantity: 1)

    /*-----Fill First Entery Flavor Text------*/
    //Forest
    forest.enterText = "You find yourself in a wooded area. The sun shines bright through the leaves and warms your face. What brought you here? You can't remember. You should LOOK AROUND and try to get a lay of the land."
    //building
    building.enterText = "You insert the key you found into the shacks lock. The rusty sounds of tumblers turning is music to your ears. The door opens to reveal a small dusty room."
    //cave
    cave.enterText = "You enter into the cave. It twists and turns for some time before opening opening into a large chamber. As you step forward the earth shakes while the wall shifts to form a rocky face.\n\nGreetings small one! It has been some time since someone has visited me."
    //riddleRoom
    riddleRoom.enterText = "The mouth of the door opens wide making a gateway for you to enter. Upon entering you find yourself in a quant study."
    //cellar
    cellar.enterText = "You climb down a rotting staircase into the cellar. The air is stale and tickles your throat as you inhale."
    //spiritTree
    spiritTree.enterText = "You win the game."
    /*-----Fill Look around Flavor Text------*/
   //Forest
    forest.lookText = "A survey of the area reveals a small shack with curtained windows, a cave near the cliffside, and a path leading deeper into a heavily overgrown part of the woods."
    //building
    building.lookText = "Looking around you see tattered sheets covering the windows. The floor looks to be made out of loose sticks. As you walk around you get the feel that you could easily pick up some of the sticks."
    //cave
    cave.lookText = "When you look around you notice a skeleton propped against the wall with a glimmering key hanging from its neck."
    //riddleRoom
    riddleRoom.lookText = "You notice a scroll on a desk in the study"
    //cellar
    cellar.lookText = "The cellar is filled with barrels. Most of which are broken. The ones that aren't are unfortuantely empty. On the "
    //spiritTree
    spiritTree.lookText = "You done now. Leave"
    
    /*---Initialize Rejection text---*/

    //Forest
    forest.rejectionText = "This shouldn't happen."
    //building
    building.rejectionText = "The door is locked"
    //cave
    cave.rejectionText = "I'm not going in there it's too dark"
    //riddleRoom
    riddleRoom.rejectionText = "HA! Wrong! C'mon give it another go!"
    //cellar
    cellar.rejectionText = "You can't do that."
    //spiritTree
    spiritTree.rejectionText = "You walk down the path for what feels like hours before stepping out of the woods seemingly right where you started. You must have gotten turned around somewhere."
    /*---Initialize Setting Enventory---*/
    //Forest
    forest.inventory.insert(Item.new(item: "flint", quantity: 1)!)
    forest.inventory.insert(Item.new(item: "stick", quantity: 1)!)
    forest.inventory.insert(Item.new(item: "cloth", quantity: 1)!)
    //building
    building.inventory.insert(Item.new(item: "stick", quantity: 15)!)
    //cave
    cave.inventory.insert(Item.new(item: "key", quantity: 1)!)
    //riddleRoom
    riddleRoom.inventory.insert(Item.new(item: "map", quantity: 1)!)
    //cellar
    cellar.inventory.insert(Item.new(item: "journal", quantity: 1)!)
    //spiritTree
    
    // Save Areas
    do {
        try manager.saveArea(area: forest)
        try manager.saveArea(area: building)
        try manager.saveArea(area: riddleRoom)
        try manager.saveArea(area: cave)
        try manager.saveArea(area: cellar)
        try manager.saveArea(area: spiritTree)
        return forest
    } catch {
        return nil
    }
}

func makeNewGame(manager: SCMDatabaseManager, handler: SCMMessageHandler, id: SCMIdentifier) {
    // Create a new game
    var player = Player(id: id)
    
    // Create initial location
    guard let initialLocation = buildAreas(using: manager) else { return }
    
    player.currentArea = initialLocation.id
    
    let introductoryText = "You wake up in a forest. You know not who you are, where you're going, nor where you've been."
    
    let message = FBMessage(text: introductoryText, recipientId: player.id)
    handler.sendMessage(message)
    
    try? manager.savePlayer(player: player)
}





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
    
    let json = try JSON(bytes: data)
    
    let handler = SCMMessageHandler(app: drop)
    handler.handleAsync(json: json, callback: { (payload) in
        
        let id = payload.senderId
        guard let manager = SCMDatabaseManager() else { return }
        
        if let message = payload.message {
            guard let player = try? manager.retrievePlayer(withId: id) else {
                makeNewGame(manager: manager, handler: handler, id: id)
                return
            }
            
            if message == "buttons" {
                let buttons = [
                    FBButton(type: .postback, title: "Button 1", payload: "Button1"),
                    FBButton(type: .postback, title: "Button 2", payload: "Button2"),
                    FBButton(type: .postback, title: "Button 3", payload: "Button3")
                ]
                
                let message = FBMessage(text: "This message has buttons!", recipientId: id)
                for button in buttons {
                    try? message.addButton(button: button)
                }
                
                handler.sendMessage(message, withResponseHandler: { (response: Response?) -> Void in
                    console.log(response?.bodyString)
                })
                
            } else {
                let message = FBMessage(text: "You've already been here, please come back later.", recipientId: id)
                handler.sendMessage(message, withResponseHandler: { (response) -> (Void) in
                    console.log(response?.bodyString)
                })
            }
        }
        
        if let postback = payload.postback {
            guard let recognizedPostback = Postback(rawValue: postback) else {
                // We got a postback, but it is unrecognized.
                
                let message = FBMessage(text: "Received Postback: \(postback)", recipientId: id)
                handler.sendMessage(message)
                return
            }
            
            switch recognizedPostback {
            case .getStartedButtonPressed:
                
                makeNewGame(manager: manager, handler: handler, id: id)
                return
            }
            
        }
        
    })

    console.log("Request returning successfully")
    return Response(status: .ok)
}

// Do some other stuff
drop.resource("posts", PostController())

// Run it
drop.run()

