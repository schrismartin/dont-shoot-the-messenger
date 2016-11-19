import MongoKitten

public struct Player {
    public var id: SCMIdentifier
	public var inventory: Set<Item> = []
	public var health: Int = Player.maxStat
	public var hunger: Int = Player.maxStat
	public var hydration: Int = Player.maxStat
    public var dead: Bool {
        return health >= 0
    }
    public var currentArea: ObjectId?
	public static let maxStat = 20
	
	/*	too be implimented
	public var awareness: Int
	public var sanity: Int
	public var sleep: Int
	*/
	//called every time health is changed
    
	//called when food is eaten
	public func applyEat(hydro: Int, hung: Int) -> Player {
        var newPlayer = self
		newPlayer.hydration = (hydration + hydro) % Player.maxStat
		newPlayer.hunger = (hunger + hung) % Player.maxStat
        return newPlayer
	}
    
	public func eat (yummy: Food) -> Player {
		if (hydration == Player.maxStat && hunger == Player.maxStat){
			//tell them they're full
			return self
		} else if (hydration == Player.maxStat){
				//tell them theyre not thirst but they will eat it
			} else if (hunger == Player.maxStat) {
				// tell them theyre not hungry but they'll eat it
			}
		return applyEat(hydro: yummy.thirstValue, hung: yummy.hungerValue)
//		print(yummy.eatText)

	}
	//adjust players stats based on his current stats. Called once per day at dawn
	public func checkUp (){


	}
	//should have startig parameters from the database of progress to construct current inventory
    
    public init(id: SCMIdentifier) {
        self.id = id
    }
}

// Add a document calculated property for easy database storage
extension Player: DatabaseRepresentable {
    
    public init(document: Document) {
        // Grab id
        self.id = SCMIdentifier(string: document["facebookId"].string)
        
        // get inventory
        let inv = document["inventory"].storedValue as! Document
        let arr = inv.arrayValue
        self.inventory = Set( arr.map { Item.new(fromValue: $0)! } )
        
        // Get rest
        self.health = document["health"].int
        self.hunger = document["hunger"].int
        self.hydration = document["hydration"].int
        self.currentArea = document["currentArea"].objectIdValue!
    }
    
    public var document: Document {
        
        let inv = Document(array: self.inventory.map { $0.value })
        
        let playerDoc: Document = [
            "_id" : ~id.objectId!,
            "facebookId": ~id.string,
            "inventory" : ~inv,
            "health": ~health,
            "hunger": ~hunger,
            "hydration": ~hydration,
            "currentArea": ~(currentArea ?? "nil")
        ]
        
        return playerDoc
    }
}


