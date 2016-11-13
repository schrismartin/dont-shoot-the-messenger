import Vapor
import Library
import MongoKitten
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
    
    //Set names
    forest.name = "The Forest"
    cave.name = "The Dark Cavern"
    riddleRoom.name = "The Chamber of the Riddle Master"
    spiritTree.name = "The Sacred Grove"
    building.name = "Old Shack"
    cellar.name = "The Dank Cellar"

    //Set paths between areas
    forest.paths.insert(spiritTree)
    forest.paths.insert(cave)
    forest.paths.insert(building)

    building.paths.insert(cellar)
    building.paths.insert(forest)

    cellar.paths.insert(cellar)

    cave.paths.insert(riddleRoom)
    cave.paths.insert(forest)

    riddleRoom.paths.insert(cave)

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

}

class SCMGameManager {
    var database: MongoKitten.Database
    
    public init?() {
        
        // Create the database
        do {
            guard let hostname = drop.config["app", "mongo-db"]?.string else {
                return nil
            }
            
            let mongoServer = try Server(hostname: hostname)
            try mongoServer.connect()
            
             self.database = mongoServer["dontshoot"]
        } catch {
            print("Could not connect to server. Exiting")
            return nil
        }
    }
    
    public func createNewGame() {
        let area = Area()
        
        do {
            try saveArea(area: area)
        } catch {
            print("Saving of Area Failed")
        }
    }
    
    func saveArea(area: Area) throws {
        let areaCollection = database["area"]
        try areaCollection.insert(area.databaseEntry)
    }
    
    func retrieveArea(withId objectId: ObjectId) throws -> Area {
//        let areaCollection = database["area"]
//        let areaDoc = try areaCollection.findOne(matching: "id" == objectId)
//        
//        let adjacentAreas = areaDoc?["paths"].document
        return Area()
    }
}

let drop = Droplet()

let manager = SCMGameManager()
manager?.createNewGame()

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

drop.post("fbwebhook") { request in
    
    guard let data = request.body.bytes else {
        // There was no real data
        print("Data could not be determined")
        return Response(status: .badRequest, body: "Data could not be determined")
    }
    
    let json = try JSON(bytes: data)
    
    let handler = SCMMessageHandler(drop: drop)
    let message = try handler.handle(json: json)
    
    // temp player and area objects
    let player = Player()
    let area = Area()

//    parse(input: message,player: player,area: area)

    let test: [String] = ["this is a TEST file to see if i can use this","And another one"]
    parse(input: test,player: player,area: area)

    print("Things worked out")
    return Response(status: .ok, body: "Things worked out")
}

// Do some other stuff
drop.resource("posts", PostController())

// Run it
drop.run()

