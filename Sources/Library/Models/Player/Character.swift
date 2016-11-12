public class Player {
	public var inventory: [String: Int] //dictionary keyed on Item names with value equaling current quantity of the Item
	public var health: Int
	public var hunger: Int
	public var hydration: Int
	public var dead: Bool
	public static let maxStat = 20
	/*	too be implimented
	public var awareness: Int
	public var sanity: Int
	public var sleep: Int
	*/
	//called every time health is changed
	func checkHealth (){
		if (health <= 0){
			dead = true;
		}
		if (health > Player.maxStat){
			health = Player.maxStat
		}
		if (dead) {
			//Tell them they are dead
		}
	}
	//called when food is eaten
	func applyEat(hydro: Int, hung: Int){
		hydration = (hydration + hydro) % Player.maxStat
		hunger = (hunger + hung) % Player.maxStat
	}
	func eat (yummy: Food){
		if (hydration == Player.maxStat && hunger == Player.maxStat){
			//tell them they're full
			return
		} else if (hydration == Player.maxStat){
				//tell them theyre not thirst but they will eat it
			} else if (hunger == Player.maxStat) {
				// tell them theyre not hungry but they'll eat it
			}
		applyEat(hydro: yummy.thirstValue, hung: yummy.hungerValue)
		print(yummy.eatText)

	}
	//adjust players stats based on his current stats. Called once per day at dawn
	func checkUp (){


	}
	//should have startig parameters from the database of progress to construct current inventory
	init (i: Int) {
		//New game
		if (i == 0){
			inventory = [:]
			health = Player.maxStat
			hunger = Player.maxStat
			hydration = Player.maxStat
			dead = false
		} else {
			//change later this is for compiling purposes
			inventory = [:]
			health = Player.maxStat
			hunger = Player.maxStat
			hydration = Player.maxStat
			dead = false
		}
	}
}


