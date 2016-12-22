//
//  SCMGameManager.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/13/16.
//
//

import Vapor
import MongoKitten
import HTTP
import Foundation

public class SCMGameManager {
    internal var database: MongoKitten.Database
    
    public init?() {
        
        // Create the database
        do {
            let hostname = "mongodb://master:dontshoot@ds151707.mlab.com:51707"
            let mongoServer = try Server(mongoURL: hostname, automatically: true)
            
            self.database = mongoServer["dont-shoot-the-messenger"]
        } catch {
            print("Could not connect to server. Exiting")
            return nil
        }
    }
    
    public func createNewGame(forPlayer player: Player) {
        let area = Area()
        player.currentArea = area.id
        
        do {
            try saveArea(area: area)
        } catch {
            print("Saving of Area Failed")
        }
    }
    
    public func saveArea(area: Area) throws {
        let areaCollection = database["area"]
        try areaCollection.insert(area.document)
    }
    
    public func retrieveArea(withId objectId: ObjectId) throws -> Area? {
        let areaCollection = database["area"]
        let playerDoc = try areaCollection.findOne(matching: "_id" == objectId)
        
        if let document = playerDoc {
            return Area(document: document)
        } else {
            return nil
        }
    }
    
    public func savePlayer(player: Player) throws {
        let playerCollection = database["player"]
        try playerCollection.insert(player.document)
    }
    
    public func retrievePlayer(withId identifier: SCMIdentifier) throws -> Player? {
        let areaCollection = database["player"]
        let playerDoc = try areaCollection.findOne(matching: "_id" == identifier.objectId)
        
        if let document = playerDoc {
            return Player(document: document)
        } else {
            return nil
        }
    }
}
