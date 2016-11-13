public class Cloth: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Stick"] = "Torch"
        name = "Cloth"
	}
}

public class Flint: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Torch"] = "Lit_Torch"
        name = "Flint"
	}
}

public class Stick: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Cloth"] = "Torch"
//		keywords ["Flint"] = "Campfire"
        name = "Stick"
	}
}

public class Map: Item {
    public override init(quantity: Int){
		super.init(quantity: quantity)
        name = "Map"
	}
}

public class Torch: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
		keywords ["Flint"] = "Lit_Torch"
        name = "Torch"
	}
}


public class LitTorch: Item {
    public override init(quantity: Int){
		super.init(quantity: quantity)
        name = "Lit_Torch"
	}
}


/*-------------------------------------*/
public class Journal: Item {
	public override init(quantity: Int){
		super.init(quantity: quantity)
        name = "Journal"
	}
}
    
public class Key: Item {
	public override init (quantity: Int){
		super.init(quantity: quantity)
        name = "Key"
	}
}
// Vines
// Rock
