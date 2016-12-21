//
//  LocationArchetype.swift
//  the-narrator
//
//  Created by Chris Martin on 11/18/16.
//
//

import Foundation
import MongoKitten

struct LocationArchetype: DatabaseRepresentable {
    
    var id: ObjectId
    var name: String
    
    public init(document: Document) {
        // Get identifiers
        self.id = document["_id"].objectIdValue!
        self.name = document["name"].string
    }
    
    public var document: Document {
        
        let doc: Document = [
            "_id" : ~id,
            "name" : ~name,
        ]
        
        return doc
    }
}
