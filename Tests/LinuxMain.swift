import XCTest
@testable import LibraryTests

XCTMain([
     testCase(PostTests.allTests),
     testCase(SCMIdentifierTests.allTests),
])

