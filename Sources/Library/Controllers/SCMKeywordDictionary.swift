//
//  SCMKeywordDictionary.swift
//  the-narrator
//
//  Created by Chris Martin on 11/22/16.
//
//

import Foundation
import MongoKitten

class SCMKeywordDictionary {
    
    var keywords: [String : String] = [:]
    
    static let shared = SCMKeywordDictionary()
    
    init() {
        self.keywords = [
            "run" : "go",
            "walk" : "go",
            "swim" : "go",
            "climb" : "go",
            "crawl": "go",
        ]
    }
    
}
