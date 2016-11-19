//
//  ConfigService.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/17/16.
//
//

import Vapor
import MongoKitten
import HTTP
import Foundation

public class ConfigService {
    public static let shared = ConfigService()

    var facebookAccessToken: String = "EAATAd74WSvYBAPtS61XEFDMLuKjtsOtxw5rlgI3lWgzkv06mU7WHQH5YBklVu09Q0FqwsjQrD5vVtnZBYu5EKi0rWWP5BFlZBvuU58KfyeizwvzLetDj0l68KJAdljQxqQmJeZAuGpG6YaGKZCCtNp5cYHpJwUz1GHC0SDZA67AZDZD"
    var mongoURI: String = "mongodb://master:dontshoot@ds151707.mlab.com:51707"
}
