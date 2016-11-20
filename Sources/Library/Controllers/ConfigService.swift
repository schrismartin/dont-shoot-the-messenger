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

    var facebookAccessToken: String = "EAATAd74WSvYBAFne0E17ZCJLgJ0GKoZBZCUD6tykvEGLuLrtgFDtH0bFHSXnuznCB6axTdzoNF4k9DdsFd6JlJHEfaX1DH9o5i2vsItIEZCNDXpMCL01Pzql0KMsFIZAtbzHhhrZBzkHf6b1K92GlQsRDjzKrg6x4Xz1l9SRLRwgZDZD"
    var mongoURI: String = "mongodb://master:dontshoot@ds151707.mlab.com:51707"
}
