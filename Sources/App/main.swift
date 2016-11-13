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



drop.resource("posts", PostController())

drop.run()
