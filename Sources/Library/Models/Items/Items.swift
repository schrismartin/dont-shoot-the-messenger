import Vapor
import Fluent
import Foundation

let input = "Light the torch"
let verb = "light"
let object = "torch"

/*if let lightableObject = Item.new(name: object, quantity: 2) as? Lightable {
	lightableObject.light()
} else {
	print("You can't do that, silly!")
}
*/


public class Item: Hashable {
	public var name: String
	public var id: Int {
		return name.hashValue
	}

	public var keywords: [String: String] //a map of items the current item can be used with and the resulting output item
	public var quantity: Int
	public var responder: Responder?

	//Should we be double hashing?
	public var hashValue: Int {
		return id.hashValue
	}

	public static func ==(lhs: Item, rhs: Item) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}
    
    public static func new(item: String, quantity: Int) -> Item? {
        switch item {
            case "Stick": return Stick(quantity: quantity)
            case "Map": return Map(quantity: quantity)
            case "Torch": return Torch(quantity: quantity)
            case "Lit_Torch": return LitTorch(quantity: quantity)
            case "Key": return Key(quantity: quantity)
            default: return nil
        }
    }

	public static func new(name: String, quantity: Int) -> Item {
		switch name {
			case "Stick":
				return Stick(quantity: quantity)
			case "Map":
				return Map(quantity: quantity)
			case "Torch":
				return Torch(quantity: quantity)
			case "Lit_Torch":
				return LitTorch(quantity: quantity)
			case "Key":
				return Key(quantity: quantity)
			default :
				return Item()
		}
	}

	func use() -> Bool {
		if quantity > 0 {
			quantity -= 1
			return true
		} else {
			return false
		}
	}
    
    public init(quantity: Int){
		name = ""
		keywords = [:]
		self.quantity = quantity
	}
}
public protocol Responder{

}

public protocol Flamable {
	func light()
}

public protocol Breakable {
	func destroy()
}

public protocol Throwable {
	func toss()

}

public protocol Shelter {
	func sleepIn()
	func hideUnder()
}

//OTHER ITEMS?

//SHELTER ITEMS
/*
public class Stick: Item, Flamable, Breakable {
	func light() {
		// Do this when we light the stick
	}

	func destroy() {
		// Do this when we break the stick
	}
}

*/
