public class Player {
	public var inventory: [Item]
	public var health: Int
	public var hunger: Int
	public var hydration: Int
	public var dead: Bool
	public static let maxStat = 20
	
	//public var areaID: String
	
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
	init (inventory: [Item], health: Int, hunger: Int, hydration: Int, dead: Bool){
		self.inventory = inventory
		self.health = health
		self.hunger = hunger
		self.hydration = hydration
		self.dead = dead
	}
	init (){
		inventory = []
		health = Player.maxStat
		hunger = Player.maxStat
		hydration = Player.maxStat
		dead = false
	}
}



