//
//  DecisionTree.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/21/16.
//
//

import Foundation

class DecisionTree {
    var entryPoint: DecisionNode
    
    func interact() {
        // Implement
    }
    
    init(entryPoint: DecisionNode) {
        self.entryPoint = entryPoint
    }
}

class DecisionNode {
    var playerText: String?
    var responseText: String?
    var next: [DecisionNode] = []
    var itemGiven: Item2?
    var itemTaken: Item2?
    var buffGiven: Buff?
    var stateAppended: Int = 0
}
