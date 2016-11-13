import MongoKitten

public class Area {
    public var id: ObjectId
	public var name: String
	public var inventory: Set<Item>
	public var paths: Set<Area>
	public var enterText: String
	public var lookText: String
	public var rejectionText: String
	public var visits: Int
	public var eConditionI: Item? //compare if player inventory quantity is greater than needed
	public var eConditionW: String? //compare if equal to
	public var eConditionE: Item? // compare if current environment quantity is less than needed

	public init(){
        let items = ["stick",
                     "map",
                     "torch",
                     "lit_torch",
                     "key", 
            		 "journal",
            		 "cloth",            
            		 "flint"
                     ]
        
        id = ObjectId()
        inventory = Set(items.map { Item.new(item: $0, quantity: 0)! })
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
    
    public var databaseEntry: Document {
        let inventory = self.inventory.map {
            ["name": ~$0.name, "quantity": ~$0.quantity] as Value
        }
        
        let inv = Document(array: inventory)
        
        let paths = Document(array: self.paths.map { Value(stringLiteral: $0.id.hexString) })
        
        let areaDoc: Document = [
            "id" : ~id,
            "name" : ~name,
            "inventory" : ~inv,
            "paths" : ~paths,
            "enterText": ~enterText,
            "generalText": ~lookText,
            "eConditionI": ~(eConditionI?.name ?? "nil"),
            "eConditionW": ~(eConditionW ?? "nil"),
            "eConditionE": ~(eConditionE?.name ?? "nil")
        ]
        
        
        return areaDoc
    }
}

public extension Area {
    public convenience init(id: ObjectId, inventory: [(String, Int)], paths: Set<Area>, enterText: String, lookText: String, name: String) {
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












