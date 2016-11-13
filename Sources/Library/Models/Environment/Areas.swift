public class Area {
	public var name: String
	public var inventory: [Item]
	public var paths: [Area]
	public var enterText: String
	public var generalText: String
	
	public var eConditionI: Item?
	public var eConditionW: String?
	public var eConditionE: Item?

	public init(){
		inventory = []
		paths = []
		enterText = ""
		generalText = ""
		name = ""
	}
}













