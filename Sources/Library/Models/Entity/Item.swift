//
//  Item.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/21/16.
//
//

import Foundation
import MongoKitten

public class Item2: Entity {
    var effect: Buff?
    
    func activate() {
        delegate?.activate(entity: self)
    }
}

public struct Buff {
    
    public enum BuffType {
        case healthRegeneration
        case Invisibility
        case addHealth
        case removeHealth
    }
    
    var duration: Int
    var intensity: Int
    var buffType: BuffType
    
    
}
