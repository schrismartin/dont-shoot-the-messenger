public class Cloth: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Stick"] = "Torch"
	}
}

public class Flint: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Torch"] = "Lit_Torch"
	}
}

public class Stick: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Cloth"] = "Torch"
//		keywords ["Flint"] = "Campfire"
	}
}

public class Map: Item {
    public override init(quantity: Int){
		super.init(quantity: quantity)
	}
}

public class Torch: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Flint"] = "Lit_Torch"
	}
}


public class LitTorch: Item {
    public override init(quantity: Int){
		super.init(quantity: quantity)
	}
}


/*-------------------------------------*/
public class Journal: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
	}
}
    
public class Key: Item {
	public override init (quantity: Int){
		super.init(quantity: quantity)
	}
}
// Vines
// Rock
