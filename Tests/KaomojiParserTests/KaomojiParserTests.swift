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
            XCTAssertEqual(parser.search(in: "嬉しいです(≧▽≦)"), ["(≧▽≦)"])
            XCTAssertEqual(parser.search(in: "地震だ！┗(^o^;)┓"), ["┗(^o^;)┓"])
            XCTAssertEqual(parser.search(in: "またね(・Д・)ノ"), ["(・Д・)ノ"])
            XCTAssertEqual(parser.search(in: "ホームランｷﾀ━━━━(ﾟ∀ﾟ)━━━━‼︎"), ["ｷﾀ━━━━(ﾟ∀ﾟ)━━━━‼︎"])
            XCTAssertEqual(parser.search(in: "嫌い(｀ε´)　絶交しよ( ￣っ￣)"), ["(｀ε´)　", "( ￣っ￣)"])
        }
    }
