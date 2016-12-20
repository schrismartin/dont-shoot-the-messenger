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

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public class SCMConfig {

    public static var facebookAccessToken: String {
        guard let env = getEnvVar(name: "FACEBOOK_ACCESS_TOKEN")  else {
            console.log("Environment Variable FACEBOOK_ACCESS_TOKEN could not be found.")
            return ""
        }
        
        return env
    }
    
    public static var mongoURI: String {
        guard let env = getEnvVar(name: "MONGO_DB_URI") else {
            console.log("Environment Variable MONGO_DB_URI could not be found.")
            return ""
        }
        
        return env
    }
    
    public static var readDelay: Int {
        let defaultValue = 2
        
        guard let delay = getEnvVar(name: "MESSAGE_READ_DELAY") else {
            console.log("Environment Variable READ_TIME could not be found")
            return defaultValue
        }
        
        return Int(delay) ?? defaultValue
    }
    
    public static var sendDelay: Double {
        let defaultValue: Double = 1
        
        guard let delay = getEnvVar(name: "MESSAGE_SEND_DELAY") else {
            console.log("Environment Variable READ_TIME could not be found")
            return defaultValue
        }
        
        return Double(delay) ?? defaultValue
    }
    
    public static var urlBase: String {
        guard let env = getEnvVar(name: "FACEBOOK_BASE_URL") else {
            console.log("Environment Variable FACEBOOK_BASE_URL could not be found.")
            return "https://graph.facebook.com/v2.8/me/messages?access_token="
        }
        
        return env
    }
}

extension SCMConfig {

    fileprivate static func getEnvVar(name: String) -> String? {
        let secretEnv = Droplet().config["app", name]?.string
        
        guard let env = getenv(name),
            let herokuEnv = String.init(validatingUTF8: env) else { return secretEnv }
        return herokuEnv
    }
    
    fileprivate static func logLoad(str: String) {
        console.log("Loaded environment variable as \(str)")
    }
    
}
