//
//  Entity.swift
//  the-narrator
//
//  Created by Chris Martin on 11/21/16.
//
//

import Foundation
import MongoKitten

public class Entity {
    
    public var name: String
    public var id: ObjectId
    public var description: String
    public var delegate: EntityDelegate?
    
    public init(name: String, id: ObjectId = ObjectId(), description: String) {
        self.name = name
        self.id = id
        self.description = description
    }
    
}

public protocol EntityDelegate {
    func activate(entity: Entity)
}
