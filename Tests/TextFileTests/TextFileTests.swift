import XCTest
@testable import TextFile

final class TextFileTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TextFile().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
