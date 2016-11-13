import Vapor
import Library
import MongoKitten

let drop = Droplet()





do {
    let mongoServer = try Server(hostname: "mongodb://master:dontshoot@ds151707.mlab.com:51707/dont-shoot-the-messenger")
	try mongoServer.connect()
	let dontshoot = mongoServer["dontshoot"]
	let users = dontshoot["users"]
    
    // Define Routes
    
    drop.get("/") { req in
        do {
            guard let userDocument = try users.findOne(matching: "_id" == ObjectId("thisndgs")) else {
                return "I don’t know you.."
            }

        } catch {
            return "there was a problem getting with users.findOne"
        }
        
        return "Made it to end without returning something"
    }
    
    // Do some other stuff
    drop.resource("posts", PostController())

    // Run it
	drop.run()
} catch {
	print("Cannot connect to MongoDB")
}


