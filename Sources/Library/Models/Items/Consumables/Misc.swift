// Cloth
// Flint
// Rock
// Stick
public class Stick: Item {
	override init(){
		super.init()
		keywords ["Cloth"] = "Torch"
		keywords ["Flint"] = "Campfire"
	}
}
public class Key: Item {
	public init(x :Int){
		super.init()
		quantity = 1
	}
}
// Vines