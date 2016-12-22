//
//  SCMIdentifierTests.swift
//  the-narrator
//
//  Created by Chris Martin on 11/17/16.
//
//

import XCTest
@testable import Library

class SCMIdentifierTests: XCTestCase {
    
    func testConversion() {
        let ids = ["0000000000000000",
                   "1111111111111111",
                   "2222222222222222",
                   "3333333333333333",
                   "4444444444444444",
                   "5555555555555555",
                   "6666666666666666",
                   "7777777777777777",
                   "8888888888888888",
                   "9999999999999999",
                   "1",
                   "Jimmy",
                   "UnexpectedResult"]
        
        for string in ids {
            let identifier = SCMIdentifier(string: string)
            XCTAssertNotNil(identifier.objectId)
        }
    }
    
    
    static var allTests : [(String, (SCMIdentifierTests) -> () throws -> Void)] {
        return [
            ("testConversion", testConversion)
        ]
    }
}
