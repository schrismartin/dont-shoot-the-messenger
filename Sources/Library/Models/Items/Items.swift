import Vapor
import Fluent
import Foundation


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

	func use() -> Bool {
		if quantity > 0 {
			quantity -= 1
			return true
		} else {
			return false
		}
	}
	init(){
		name = ""
		keywords = [:]
		quantity = 0
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







/*



//SHELTER ITEMS

public class Stick: Item, Flamable, Breakable {
	func light() {
		// Do this when we light the stick
	}

	func destroy() {
		// Do this when we break the stick
	}
}

*/
