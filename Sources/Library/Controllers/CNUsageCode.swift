//
//  CNUsageCode.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/17/16.
//
//

import Foundation

// Chris Nagy's Code Start

/// If the actions was recognized, call that actions function and return true; else return false
public func findAction(index: Int, parsedText: [String], player: Player, area: Area) -> Bool{
    switch parsedText[index] {
    case "use":
        use(index: index,parsedText: parsedText,player: player, area: area)
        return true
    case "go":
        go(index: index,parsedText: parsedText,player: player, area: area)
        return true
    case "pickup":
        pickUp(index: index,parsedText: parsedText,player: player, area: area)
        return true
    case "look":
        look(index: index,parsedText: parsedText,player: player, area: area)
        return true
    case "inventory":
        inventory(index: index,parsedText: parsedText,player: player, area: area)
        return true
    default:
        return false
    }
}
//print player inventory
public func inventory(index: Int, parsedText: [String], player: Player, area: Area) {
    print("Inventory:\n")
    for i in player.inventory {
        print ("\(i.quantity)  \(i.name)(s) ")
    }
}

//attempt to combine two items
public func use(index: Int, parsedText: [String], player: Player, area: Area) {
    //check player inventory
    for i in index..<parsedText.count{
        print("\(i) = \(parsedText[i])")
        for j in 0..<player.inventory.count{
            //check if the first item is in inventory
            if (parsedText[i] == player.inventory.array[j].name && player.inventory.array[j].quantity > 0){
                //find second item in parsedText
                for i in i..<parsedText.count{
                    //check if the second item is viable to use with the first item
                    //for k
                    //if (parsedText[i] == player.inventory.array[j].keywords)
                }
                //and that it is in the players inventory
                
            }
        }
    }
    print("You can't do that.\n")
}

//Pickup
public func pickUp(index: Int, parsedText: [String], player: Player, area: Area) {
    //check environment inventory
}



//Go
public func go(index: Int, parsedText: [String], player: Player, area: Area) {
    //check Area paths
}




//Look
public func look(index: Int, parsedText: [String], player: Player, area: Area) {
    //area or player inventory
}
