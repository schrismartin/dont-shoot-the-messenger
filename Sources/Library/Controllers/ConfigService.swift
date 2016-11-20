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

public class ConfigService {
    public static let shared = ConfigService()

    var facebookAccessToken: String {
        guard let env = getEnvVar(name: "FACEBOOK_ACCESS_TOKEN")  else {
            console.log("Environment Variable FACEBOOK_ACCESS_TOKEN could not be found.")
            return ""
        }
        
        logLoad(str: env)
        return env
    }
    
    var mongoURI: String {
        guard let env = getEnvVar(name: "MONGO_DB_URI") else {
            console.log("Environment Variable MONGO_DB_URI could not be found.")
            return ""
        }
        
        logLoad(str: env)
        return env
    }
    
    private func getEnvVar(name: String) -> String? {
        let secretEnv = Droplet().config["app", name]?.string
        
        guard let env = getenv(name),
            let herokuEnv = String.init(validatingUTF8: env) else { return secretEnv }
        return herokuEnv
    }
    
    private func logLoad(str: String) {
        console.log("Loaded environment variable as \(str)")
    }
}
