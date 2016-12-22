//
//  Interactable.swift
//  the-narrator
//
//  Created by Chris Martin on 11/21/16.
//
//

import Foundation
import MongoKitten

class Interactable: Entity {
    var state: [Int]
    var tree: DecisionTree
    
    init(name: String, tree: DecisionTree, id: ObjectId, description: String, state: [Int]) {
        self.state = state
        self.tree = tree
        
        super.init(name: name, id: id, description: description)
    }
}
