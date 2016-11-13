// Cloth
// Flint
// Rock
public class Stick: Item {
	public override init(){
		super.init()
		keywords ["Cloth"] = "Torch"
		keywords ["Flint"] = "Campfire"
	}
	public init(x:Int){
		super.init()
		quantity = x;
	}
}
public class Map: Item {
	public init (x: Int){
		super.init()
		quantity = x
	}
}
public class Torch: Item {
	public override init(){
		super.init() 
		keywords ["Flint"] = "Lit_Torch"
	}
}
public class LitTorch: Item {
	public init(x :Int){
		super.init()
		quantity = x
	}
}
public class Key: Item {
	public init(x :Int){
		super.init()
		quantity = x
	}
}
// Vines