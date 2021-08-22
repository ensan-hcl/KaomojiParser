    import XCTest
    @testable import KaomojiParser

    final class KaomojiParserTests: XCTestCase {
        func testParser() {
            let parser = KaomojiParser()
            XCTAssertEqual(parser.search(from: "嬉しいです(≧▽≦)", G: 3, L: 3), ["(≧▽≦)"])
        }
    }
