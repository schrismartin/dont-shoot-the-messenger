public class Cloth: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		name = "cloth"
		pickupText = "You add \(quantity) \(name) to your inventory."
		desctiption = "I'd use it to blow my nose but I think it might come in handy later."
		keywords ["stick"] = "torch"
	}
}

public class Flint: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		name = "flint"
		pickupText = "You add \(quantity) \(name) to your inventory."
		desctiption = "Striking it makes sparks. Useful to start fires."
		keywords ["torch"] = "lit_torch"
	}
}

public class Stick: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		name = "stick"
		pickupText = "You add \(quantity) \(name) to your inventory."
		desctiption = "I've been told these will poke your eye out."
		keywords ["cloth"] = "torch"
//		keywords ["flint"] = "Campfire"
	}
}

public class Map: Item {
    public override init(quantity: Int){
		super.init(quantity: quantity)
		name = "map"
		pickupText = "You add \(quantity) \(name) to your inventory."
		desctiption = "A map that details the surrounding area. Now i wont get lost!"
	}
}

public class Torch: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		name = "torch"
		pickupText = "You add \(quantity) \(name) to your inventory."
		desctiption = "Now I just need something to light it and I'll have a portable light source."
		keywords ["flint"] = "lit_torch"
	}
}


public class LitTorch: Item {
    public override init(quantity: Int){
		super.init(quantity: quantity)
		name = "lit_torch"
		pickupText = "You add \(quantity) \(name) to your inventory."
		desctiption = "This should help in those dark areas."
	}
}


/*-------------------------------------*/
public class Journal: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		name = "journal"
		pickupText = "You add \(quantity) \(name) to your inventory."
		desctiption = "The journal tells you the door in the cave's name is Franky."
	}
}
    
public class Key: Item {
	public override init (quantity: Int){
		super.init(quantity: quantity)
		name = "key"
		pickupText = "You add \(quantity) \(name) to your inventory."
		desctiption = "A small brass key."
	}
}
// Vines
// Rock
