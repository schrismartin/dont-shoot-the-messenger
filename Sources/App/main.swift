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
    riddleRoom.eConditionW = "Answer"
    //cellar
    cellar.eConditionE = Stick(quantity: 5)
    //spiritTree
    spiritTree.eConditionI = Map(quantity: 1)

    /*-----Fill Flavor Text------*/

    //No Forest Enter Conditions
    
    //building
 
    //cave
    
    //riddleRoom

    //cellar
   
    //spiritTree

    /*--------------------------------*/




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
    
    print("Things worked out")
    return Response(status: .ok, body: "Things worked out")
}

// Do some other stuff
drop.resource("posts", PostController())

// Run it
drop.run()

