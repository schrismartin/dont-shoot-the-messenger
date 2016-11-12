import Vapor
import Library

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

drop.resource("posts", PostController())

drop.run()
