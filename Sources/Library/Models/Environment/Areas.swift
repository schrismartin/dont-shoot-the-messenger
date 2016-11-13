public class Area {
	public var name: String
	public var inventory: [Item]
	public var paths: [Area]
	public var enterText: String
	public var lookText: String
	public var rejectionText: String
//	public var lookText: String
	public var visits: Int
	public var eConditionI: Item? //compare if player inventory quantity is greater than needed
	public var eConditionW: String? //compare if equal to
	public var eConditionE: Item? // compare if current environment quantity is less than needed

	public init(){
		inventory = []
		paths = []
		enterText = ""
		lookText = ""
		rejectionText = ""
		name = ""
		visits = 0
	}
}













