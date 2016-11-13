public class Food: Item {
        public var isRaw: Bool?
        public var isPoisonous: Bool?
        public var hungerValue: Int
        public var thirstValue: Int
        public var eatText: String
        public func eat() {
                quantity -= 1
        }
        override init () {
                eatText = ""
                hungerValue = 0;
                thirstValue = 0;
        }
}

public class Apple: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                hungerValue = 2
                thirstValue = 1
                name = "Apple"
        }
}

public class Nuts: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                hungerValue = 1
                thirstValue = -1
                name = "Nuts"
        }
}
public class Pear: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                hungerValue = 2
                thirstValue = 1
                name = "Pear"
        }
}
public class Berries: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                isPoisonous = false
                hungerValue = 1
                thirstValue = 1
                name = "Blue Berries"
        }
}
public class PoisonBerries: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                isPoisonous = true
                hungerValue = -1
                thirstValue = 1
                name = "Red Berries"
        }
}
public class Mushrooms: Food{
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                isPoisonous = false
                hungerValue = 1
                thirstValue = 0
                name = "Brown Button Mushrooms"
        }
}
public class PoisonMushrooms: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                isPoisonous = true
                hungerValue = -1
                thirstValue = -3
                name = "White Cap Mushrooms"
        }
}
public class Moss: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                hungerValue = 0
                thirstValue = 1
                name = "Caribou Moss" 
        }
}
public class Tubers: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                hungerValue = 2
                thirstValue = 0
                name = "Tubers" 
        }
}
public class RawFish: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                isRaw = true
                hungerValue = -3
                thirstValue = -5
                name = "Raw Fish"
<<<<<<< HEAD
                keywords ["Campfire"] = "Cooked_Fish"
=======
>>>>>>> develop
        }
}
public class DirtyWater: Food {
        override init () {
                super.init()
                eatText = "You eat the (food). It (makes you feel ____)."
                isRaw = true
                isPoisonous = true
                hungerValue = -1
                thirstValue = -3
                name = "Water"
                //output = Boiled Water
        }
}

//CRAFTABLE-----------------------------------------------------
public class Fish: Food {
        override init () {
                super.init()
                isRaw = false
                hungerValue = 3
                thirstValue = 0
<<<<<<< HEAD
                name = "Cooked_Fish"
=======
                name = "Cooked Fish"
>>>>>>> develop
        }
}
public class BoiledWater: Food {
        override init () {
                super.init()
                isRaw = false
                isPoisonous = false
                hungerValue = 0
                thirstValue = 5
<<<<<<< HEAD
                name = "Boiled_Water"
=======
                name = "Boiled Water"
>>>>>>> develop
        }
}


