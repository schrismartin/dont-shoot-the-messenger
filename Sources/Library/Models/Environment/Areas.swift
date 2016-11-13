public class Area {
	public var name: String
	public var id: Int {
		return name.hashValue
	}
	public var inventory: [Item]
	public var paths: [Area]
	public var enterText: String
	public var generalText: String
	
	public var eConditionI: Item?
	public var eConditionW: String?
	public var eConditionE: Item?

	init(){
		inventory = []
		paths = []
		infoText = ""
		name = ""
	}
}

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













