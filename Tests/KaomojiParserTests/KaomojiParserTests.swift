    import XCTest
    @testable import KaomojiParser

    final class KaomojiParserTests: XCTestCase {
        func testHalfKatakana() {
            let parser = KaomojiParser()
            XCTAssertEqual(parser.isHalfKatakana("ﾊ"), true)
            XCTAssertEqual(parser.isHalfKatakana("レ"), false)
            XCTAssertEqual(parser.isHalfKatakana("a"), false)
        }

        func testParser() {
            let parser = KaomojiParser()
            XCTAssertEqual(parser.search(from: "嬉しいです(≧▽≦)", G: 3, L: 3), ["(≧▽≦)"])
            XCTAssertEqual(parser.search(from: "地震だ！┗(^o^;)┓", G: 3, L: 3), ["┗(^o^;)┓"])
            XCTAssertEqual(parser.search(from: "またね(・Д・)ノ", G: 3, L: 3), ["(・Д・)ノ"])
            XCTAssertEqual(parser.search(from: "ホームランｷﾀ━━━━(ﾟ∀ﾟ)━━━━‼︎", G: 3, L: 3), ["ｷﾀ━━━━(ﾟ∀ﾟ)━━━━‼︎"])
            XCTAssertEqual(parser.search(from: "嫌い(｀ε´)　絶交しよ( ￣っ￣)", G: 3, L: 3), ["(｀ε´)　", "( ￣っ￣)"])
        }
    }
