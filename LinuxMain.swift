import XCTest
@testable import SipHashTests

XCTMain([
          testCase(SipHashTests.allTests),
          testCase(PrimitiveTypeTests.allTests),
          testCase(SipHashableTests.allTests),
])
