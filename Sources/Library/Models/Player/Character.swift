import MongoKitten

public class Player {
    public var id: SCMIdentifier
	public var inventory: Set<Item>
	public var health: Int
	public var hunger: Int
	public var hydration: Int
	public var dead: Bool
    public var currentArea: ObjectId
	public static let maxStat = 20
	
	/*	too be implimented
	public var awareness: Int
	public var sanity: Int
	public var sleep: Int
	*/
	//called every time health is changed
	public func checkHealth (){
		if (health <= 0){
			dead = true;
		}
		if (health > Player.maxStat){
			health = Player.maxStat
		}
		if (dead) {
			//Tell them they are dead
		}
	}
	//called when food is eaten
	public func applyEat(hydro: Int, hung: Int){
		hydration = (hydration + hydro) % Player.maxStat
		hunger = (hunger + hung) % Player.maxStat
	}
	public func eat (yummy: Food){
		if (hydration == Player.maxStat && hunger == Player.maxStat){
			//tell them they're full
			return
		} else if (hydration == Player.maxStat){
				//tell them theyre not thirst but they will eat it
			} else if (hunger == Player.maxStat) {
				// tell them theyre not hungry but they'll eat it
			}
		applyEat(hydro: yummy.thirstValue, hung: yummy.hungerValue)
		print(yummy.eatText)

	}
	//adjust players stats based on his current stats. Called once per day at dawn
	public func checkUp (){


	}
	//should have startig parameters from the database of progress to construct current inventory

    public init (id: SCMIdentifier, inventory: Set<Item> = [], health: Int = Player.maxStat, hunger: Int = Player.maxStat, hydration: Int = Player.maxStat, dead: Bool = false){
        self.id = id
		self.inventory = inventory
		self.health = health
		self.hunger = hunger
		self.hydration = hydration
		self.dead = dead
        self.currentArea = ObjectId()
	}
}

// Add a document calculated property for easy database storage
public extension Player {
    
    public convenience init?(document: Document) {
        // Grab id
        let id = SCMIdentifier(string: document["facebookId"].string)
        
        // Initialize using ID
        self.init(id: id)
        
        // get inventory
        let inv = document["inventory"].storedValue as! Document
        let arr = inv.arrayValue
        self.inventory = Set( arr.map { Item.new(fromValue: $0)! } )
        
        // Get rest
        self.health = document["health"].int
        self.hunger = document["hunger"].int
        self.hydration = document["hydration"].int
        self.dead = document["dead"].bool
        self.currentArea = document["currentArea"].objectIdValue!
    }
    
    public var document: Document {
        
        let inv = Document(array: self.inventory.map { $0.value })
        
        let playerDoc: Document = [
            "_id" : ~id.objectId,
            "facebookId": ~id.string,
            "inventory" : ~inv,
            "health": ~health,
            "hunger": ~hunger,
            "hydration": ~hydration,
            "dead": ~dead,
            "currentArea": ~currentArea
        ]
        
        return playerDoc
    }
}


