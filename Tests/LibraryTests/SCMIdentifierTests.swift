//
//  SCMIdentifierTests.swift
//  dont-shoot-the-messenger
//
//  Created by Chris Martin on 11/17/16.
//
//

import XCTest
@testable import Library

class SCMIdentifierTests: XCTestCase {
    func conversionTest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the
        let ids = ["0000000000000000",
                   "1111111111111111",
                   "2222222222222222",
                   "3333333333333333",
                   "4444444444444444",
                   "5555555555555555",
                   "6666666666666666",
                   "7777777777777777",
                   "8888888888888888",
                   "9999999999999999"]
        
        for string in ids {
//            XCTAssert(
        }
    }
    
    
    static var allTests : [(String, (SCMIdentifierTests) -> () throws -> Void)] {
        return [
            ("conversionTest", conversionTest)
        ]
    }
}
