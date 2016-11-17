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

    var facebookAccessToken: String = "EAATAd74WSvYBAFpstWfFB1fp3OJbqhL2lb1MddvxqxoduD23YqgdA1C5VXNKBBFR8qHTIMFcTEkzAqC5bZCLKZBPolvOitVxvqsxX3cHSE0KTF8Mq6URz8i3OdTivk2iQQikk99GTrIir1zvvXasyd9ZA6Y4rMhEPya61TO7QZDZD"
    var mongoURI: String = "mongodb://master:dontshoot@ds151707.mlab.com:51707"
}
