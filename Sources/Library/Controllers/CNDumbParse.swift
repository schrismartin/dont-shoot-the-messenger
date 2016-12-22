import Foundation

public func parse(input: [String],player: Player, area: Area){
	for message in input {
		console.log("NEW MESSAGE\n")
		let lower = message.lowercased()
    	let splitArray = lower.characters.split(separator:" ").map{ String($0)}
    	for i in 0..<splitArray.count{
    		console.log("\(i) = \(splitArray[i])")

    		if (findAction(index: i, parsedText: splitArray,player: player, area: area)){
    			break;
    		}
    	}
	}
}
