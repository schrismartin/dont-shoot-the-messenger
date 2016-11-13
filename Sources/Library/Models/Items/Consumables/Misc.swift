// Cloth
// Flint
// Rock
public class Stick: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Cloth"] = "Torch"
		keywords ["Flint"] = "Campfire"
	}
}

public class Map: Item {
    
}

public class Torch: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Flint"] = "Lit_Torch"
	}
}

public class LitTorch: Item {
    
}
public class Key: Item {

}
// Vines
