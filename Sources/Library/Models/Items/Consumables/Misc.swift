// Cloth
// Flint
// Rock
public class Stick: Item {
	public override init(){
		super.init()
		keywords ["Cloth"] = "Torch"
		keywords ["Flint"] = "Campfire"
	}
	public init(quantity: Int){
		super.init()
		self.quantity = quantity;
	}
}
public class Map: Item {
	public init (quantity: Int){
		super.init()
		self.quantity = quantity
	}
}
public class Torch: Item {
	public init(quantity: Int){
		super.init() 
		keywords ["Flint"] = "Lit_Torch"
	}
}
public class LitTorch: Item {
	public init(quantity: Int){
		super.init()
		self.quantity = quantity
	}
}
public class Key: Item {
	public init(quantity: Int){
		super.init()
		self.quantity = quantity
	}
}
// Vines
