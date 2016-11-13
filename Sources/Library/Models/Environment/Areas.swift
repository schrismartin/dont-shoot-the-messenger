import MongoKitten

public class Area {
    public var id: ObjectId
	public var name: String
	public var inventory: Set<Item>
	public var paths: Set<ObjectId>
	public var enterText: String
	public var lookText: String
	public var rejectionText: String
	public var visits: Int
	public var eConditionI: Item? //compare if player inventory quantity is greater than needed
	public var eConditionW: String? //compare if equal to
	public var eConditionE: Item? // compare if current environment quantity is less than needed

	public init(){
        let items = ["Stick",
                     "Map",
                     "Torch",
                     "Lit_Torch",
                     "Key"]
        
        id = ObjectId()
        let temp = items.map { Item.new(item: $0, quantity: 0)! }
        inventory = Set(temp)
		paths = []
		enterText = ""
		lookText = ""
		rejectionText = ""
		name = ""
		visits = 0
	}
}

// Add a document calculated property for easy database storage
public extension Area {
    
    public convenience init?(document: Document) {
        self.init()
        
        self.id = document["_id"].objectIdValue!
        self.name = document["name"].string
        
        // get inventory
        let inv = document["inventory"].storedValue as! Document
        let arr = inv.arrayValue

//        self.inventory = Set(invArr)
        
        // get paths
        let paths = document["paths"].storedValue as! Document
        let values = paths.arrayValue
        do {
            self.paths = Set( values.map { $0.objectIdValue! } )
        } catch { return nil }
        
        self.enterText = document["enterText"].string
        self.lookText = document["lookText"].string
        self.rejectionText = document["rejectionText"].string
        self.visits = document["visits"].int
        
        var temp = document["eConditionI"].value.makeBsonValue()
        self.eConditionI = temp.string == "nil" ? nil : Item.new(fromValue: temp)
        
        temp = document["eConditionW"].value.makeBsonValue()
        self.eConditionW = temp.string
        
        temp = document["eConditionE"].value.makeBsonValue()
        self.eConditionE = temp.string == "nil" ? nil : Item.new(fromValue: temp)
        
    }
    
    public var document: Document {
        
        let inv = Document(array: self.inventory.map { $0.value })
        
        let paths = Document(array: self.paths.map { Value(stringLiteral: $0.hexString) })
        
        let areaDoc: Document = [
            "_id" : ~id,
            "name" : ~name,
            "inventory" : ~inv,
            "paths" : ~paths,
            "enterText": ~enterText,
            "lookText": ~lookText,
            "rejectionText": ~rejectionText,
            "visits": ~visits,
            "eConditionI": ~(eConditionI?.name ?? "nil"),
            "eConditionW": ~(eConditionW ?? "nil"),
            "eConditionE": ~(eConditionE?.name ?? "nil")
        ]
        
        return areaDoc
    }
}


public extension Area {
    public convenience init(id: ObjectId = ObjectId(), name: String, inventory: [(String, Int)] = [], paths: Set<ObjectId> = Set<ObjectId>(), enterText: String, lookText: String, rejectionText: String, visits: Int = 0) {
        self.init()
        
        self.id = id
        
        for (name, quantity) in inventory {
            self.inventory.insert( Item.new(item: name, quantity: quantity)! )
        }
        
        self.paths = paths
        
        self.enterText = enterText
        
        self.lookText = lookText
        
        self.name = name
    }
}

extension Area: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: Area, rhs: Area) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}












