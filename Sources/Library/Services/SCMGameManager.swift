//
//  SCMGameManager.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/18/16.
//
//

import Vapor
import MongoKitten
import HTTP
import Foundation

public class SCMGameManager {

    public func createNewPlayer(usingIdentifier id: SCMIdentifier) -> Player {
        return Player(id: id)
    }

}
