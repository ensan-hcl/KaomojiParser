    import XCTest
    @testable import KaomojiParser

    final class KaomojiParserTests: XCTestCase {
        func testParser() {
            let parser = KaomojiParser()
            XCTAssertEqual(parser.search(from: "嬉しいです(≧▽≦)", G: 3, L: 3), ["(≧▽≦)"])
            XCTAssertEqual(parser.search(from: "地震だ！┗(^o^;)┓", G: 3, L: 3), ["┗(^o^;)┓"])
            XCTAssertEqual(parser.search(from: "またね(・Д・)ノ", G: 3, L: 3), ["(・Д・)ノ"])
        }
    }
