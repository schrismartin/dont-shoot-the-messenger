//
//  SCMGameManager.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/18/16.
//
//

import Vapor
import MongoKitten
import HTTP
import Foundation

public class SCMGameStateManager {
    
    var handler: SCMMessageHandler
    
    public init(messageHandler: SCMMessageHandler) {
        handler = messageHandler
    }
    
}

extension SCMGameStateManager {

    public func handleIncomingMessage(_ message: FBIncomingMessage) {
        
        let id = message.senderId
        guard let manager = SCMDatabaseInstance() else { return }
        
        if let message = message.text {
            guard let player = try? manager.retrievePlayer(withId: id) else {
                makeNewGame(manager: manager, handler: handler, id: id)
                return
            }
            
            if message == "Buttons" {
                let buttons = [
                    FBButton(type: .postback, title: "Button 1", payload: "Button1"),
                    FBButton(type: .postback, title: "Button 2", payload: "Button2"),
                    FBButton(type: .postback, title: "Button 3", payload: "Button3")
                ]
                
                let message = FBOutgoingMessage(text: "This message has buttons!", recipientId: id)
                for button in buttons {
                    try? message.addButton(button: button)
                }
                
                handler.sendMessage(message, withResponseHandler: { (response: Response?) -> Void in
                    console.log("Button Message Response: \(response?.bodyString)")
                })
                
            } else if let num = Int(message) {
                
                let responses = [
                    FBQuickReply(title: "One"),
                    FBQuickReply(title: "Two"),
                    FBQuickReply(title: "Three"),
                    FBQuickReply(title: "Four"),
                    FBQuickReply(title: "Five"),
                    FBQuickReply(title: "Six"),
                    FBQuickReply(title: "Seven"),
                    FBQuickReply(title: "Eight"),
                    FBQuickReply(title: "Nine"),
                    FBQuickReply(title: "Ten"),
                    FBQuickReply(title: "Eleven")
                ]
                
                let message = FBOutgoingMessage(text: "This message has quick responses!", recipientId: id)
                
                for (index, response) in responses.enumerated() where index < num {
                    try? message.addQuickReply(reply: response)
                }
                
                handler.sendMessage(message, withResponseHandler: { (response: Response?) -> Void in
                    console.log("Button Message Response: \(response?.bodyString)")
                })
            } else if message == "buttons qr" {
                
                let buttons = [
                    FBButton(type: .postback, title: "Button 1", payload: "Button1"),
                    FBButton(type: .postback, title: "Button 2", payload: "Button2"),
                    FBButton(type: .postback, title: "Button 3", payload: "Button3")
                ]
                
                let responses = [
                    FBQuickReply(title: "One"),
                    FBQuickReply(title: "Two"),
                    FBQuickReply(title: "Three"),
                    FBQuickReply(title: "Four"),
                    FBQuickReply(title: "Five"),
                    FBQuickReply(title: "Six"),
                    FBQuickReply(title: "Seven"),
                    FBQuickReply(title: "Eight"),
                    FBQuickReply(title: "Nine"),
                    FBQuickReply(title: "Ten"),
                    FBQuickReply(title: "Eleven")
                ]
                
                let message = FBOutgoingMessage(text: "This message has buttons!", recipientId: id)
                for button in buttons {
                    try? message.addButton(button: button)
                }
                
                for response in responses{
                    try? message.addQuickReply(reply: response)
                }
                
                handler.sendMessage(message, withResponseHandler: { (response: Response?) -> Void in
                    console.log("Button Message Response: \(response?.bodyString)")
                })
                
            } else if message == "story" {
                
                let story = ["I used to work as pizza delivery guy in Detroit for several years. I'm not going to tell you what part of the city I used to live in or the name of the pizza chain that employed me. It's not important, and besides it has absolutely no bearing on the story I'm about to tell.", "The neighbourhoods I used to work in were fairly safe, but sometimes I was sent to areas that had been truly devastated by the recession. If you've ever visited Detroit, or done a Google image search on \"urban blight\", you know what I'm talking about.", "The incident occurred late in the fall a few years ago, and the memory of it will stay with me until the day I die. It doesn't matter how hard I try to suppress it, or force it out of my consciousness. It always floats back up to the surface, like a dead bloated fish and lets me know that it's still there.", "Anyway here’s what happened.", "It was a Thursday evening. It had been a hectic shift and I was making the last delivery for the night. The order was going to a residence in one of the less savoury parts of town. That didn't really shock me. It was to be expected every now and again. Even folks in rough areas order pizzas and have cellphones. After all this is the US we're talking about.", "But I have to admit, I wasn't too thrilled about the possibility of getting mugged or shot. Any half decent car in a poor section of town is fair game for the local gangbangers. And believe me, there are plenty of those in Detroit.", "The house was just a tiny little fibro shack on a big corner block. There were no lights on inside, and for a brief moment I prayed that I had the wrong address. But a quick look at the mailbox out front quashed my hopes of a safe getaway.", "I cursed silently as I gazed out over the desolate property. The moon was out and that made it even creepier. I could see the grass on the lawn was knee high, and there was rubbish everywhere. The fibro sheets were riddled with holes, and the windows were boarded up with plywood and adorned with graffiti and bullet holes.", "Needless to say, I had a very bad feeling about what was about to happen, and if it had been up to me, I would have just kept on driving. But that was out of the question. I couldn't afford to lose my job, and career opportunities weren't exactly growing on trees in this city. So I stayed where I was.", "I took a few deep breaths to try to calm myself, and said a quick prayer, even though I don’t believe in God.", "Then I grabbed the pizza boxes and reached for the Coke Zero bottle next to me in the passenger seat.", "Then I found myself walking up to the house.", "The cold evening air gushing through the area was racing in and out of my lungs like pistons in a car engine. The gravel made loud crunching noises every time I put my feet down, and I kept looking around nervously, convinced that some psycho was going to jump me any second. But no one came. I was all alone.", "As I climbed the concrete stoop leading up to the porch, I noticed the front door was ajar and I stopped dead in my tracks and just stared at it. For some strange reason it scared the crap out of me, and I could feel my heart start to race along even faster.", "A voice inside my head kept telling me to get the fuck out of there, and I have to admit I seriously entertained the idea of just leaving the pizzas on the porch and take off. But I knew I couldn't. I had to follow protocol. Leaving food outside a residence was a sackable offence.", "So I walked the rest of the way to the door, and gave it a quick knock.", "The force of my fist striking the old timber made it move, and a loud guttural sound escaped from somewhere deep inside me as the squeaky hinges gave off a high pitched wail.", "But no one came to the door.", "I swallowed hard, braced myself and put my knuckles up to the door again, and this time I shouted the words 'pizza is here' into the dark void. But still there was no answer, and I foolishly believed I was off the hook.", "Then as I was about to turn around and leave, a faint, cold, raspy voice coming from somewhere deep inside the house told me to enter. I stood absolutely still, staring at the gap in the door with eyes that were ready to pop out of their sockets. And for a brief second I started wondering if I’d just imagined it.", "But then the voice called out again, and this time it kept repeating the words over and over, like it was reciting an incantation. It had a menacing quality to it, and my whole body started shaking. And that’s when I made up my mind.", "I threw the pizzas down, not really given a fuck about whether I had a job to go to the next day or not. Then I legged it.", "I jumped from the top of the stoop and ran like a lunatic down the driveway back to my car, and almost ripped the door off its hinges as I threw myself inside. My hands were shaking so badly that it took me a good ten seconds just to get the engine started.", "Then I raced out of the neighbourhood as fast as I could, gasping for air all the way back to the restaurant.", "Maybe it was the effect of the adrenaline wearing off, or maybe it was just a delayed reaction, but when I opened the door and got out of the car I threw up. A whole gutful of yellow disgusting puke.", "But at least I was alive, and that was all that mattered.", "The next morning I woke up to someone banging on my door.", "When I opened up, two police officers greeted me with stony expressions. After asking me a few questions, one of them took a step forward, looked me straight in the eyes and informed me that two pizza delivery guys had been found dead inside the house that I'd ran away from the previous evening. Both of them had been hung by the neck from an exposed joist in the lounge.", "He then pulled out a picture from the inside pocket of his jacket and handed it to me. He gave me a few seconds to study it, and then he told me that they had found the picture taped to one of the bodies. It contained three faces. Two had a big red X draw across them. The last one didn't. The last face was mine.", "I managed to look up at the officer and shake my head, before I passed out and hit the floor.", "The next day I left Detroit, and I've never been back since.", "But even now, after all this time, I always look over my shoulder when I’m out and about. I’m also pedantic about staying indoors after dark, and I always make sure my doors and windows are locked.", "The killer in Detroit was never caught, and as long as he’s out there, I’m on my guard.", "And why shouldn’t I be? He obviously knows who I am. But does he know where I live?", "Hervey Copeland"]
                
                let messages = story.map { FBOutgoingMessage.init(text: $0, recipientId: id) }
                
                handler.sendGroupedMessages(messages)
                
            } else {
                let message = FBOutgoingMessage(text: "You've already been here, please come back later.", recipientId: id)
                handler.sendMessage(message, withResponseHandler: { (response) -> (Void) in
                    console.log("Already been here response: \(response?.bodyString)")
                })
            }
        }
        
        if let postback = message.postback {
            guard let recognizedPostback = Postback(rawValue: postback) else {
                // We got a postback, but it is unrecognized.
                
                let message = FBOutgoingMessage(text: "Received Postback: \(postback)", recipientId: id)
                handler.sendMessage(message)
                return
            }
            
            switch recognizedPostback {
            case .getStartedButtonPressed:
                
                makeNewGame(manager: manager, handler: handler, id: id)
                return
            }
            
        }
        
    }
    
    func makeNewGame(manager: SCMDatabaseInstance, handler: SCMMessageHandler, id: SCMIdentifier) {
        // Create a new game
        var player = Player(id: id)
        
        // Create initial location
        guard let initialLocation = buildAreas(using: manager) else { return }
        
        player.currentArea = initialLocation.id
        
        let introductoryText = "You wake up in a forest. You know not who you are, where you're going, nor where you've been."
        
        let message = FBOutgoingMessage(text: introductoryText, recipientId: player.id)
        handler.sendMessage(message)
        
        try? manager.savePlayer(player: player)
    }

    public func createNewPlayer(usingIdentifier id: SCMIdentifier) -> Player {
        return Player(id: id)
    }

}

extension SCMGameStateManager {
    
    func buildAreas(using manager: SCMDatabaseInstance) -> Area? {
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
    
}
