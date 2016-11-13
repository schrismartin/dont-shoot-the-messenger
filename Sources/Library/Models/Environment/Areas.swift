public class Area {
	public var name: String
	public var id: Int {
		return name.hashValue
	}
	public var inventory: [Item]
	public var paths: [Area]
	public var infoText: String
	init(){
		inventory = []
		paths = []
		infoText = ""
		name = ""
	}
}

public class Beach: Area{
	override init(){
		super.init()
		let newItem = Fish.init()
		inventory.append(newItem)
		paths = []
		infoText = "You find yourself on a sandy beach. The wood of a broken raft surrounds you." 
		name = "The Beach"
	}
}
//possible infinite loop? When creating new instances of Area
public class Forest: Area{
	override init(){
		super.init()
		let newItem = PoisonMushrooms.init()
		inventory.append(newItem)
		paths = []
		infoText = "You enter into a forest. Interesting text makes you curious and eager to explore." 
		name = "The Forest"
	}
}













