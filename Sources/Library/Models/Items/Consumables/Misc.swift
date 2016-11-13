public class Cloth: Item {
	public init(quantity: Int){
		super.init()
		self.quantity = quantity
		keywords ["Stick"] = "Torch"
	}
}
public class Flint: Item {
	public init(quantity: Int){
		super.init()
		self.quantity = quantity
		keywords ["Torch"] = "Lit_Torch"
	}
}
public class Stick: Item {
	public init(quantity: Int){
		super.init()
		self.quantity = quantity;
		keywords ["Cloth"] = "Torch"
//		keywords ["Flint"] = "Campfire"
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


/*-------------------------------------*/
public class Journal: Item {
	public init(quantity: Int){
		super.init()
		self.quantity = quantity
	}
}
public class Map: Item {
	public init (quantity: Int){
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
// Rock