import XCTest

import TextFileTests

var tests = [XCTestCaseEntry]()
tests += TextFileTests.allTests()
XCTMain(tests)
