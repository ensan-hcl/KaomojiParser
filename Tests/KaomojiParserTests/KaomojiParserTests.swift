import XCTest
@testable import KaomojiParser

final class KaomojiParserTests: XCTestCase {
    func testHalfKatakana() {
        let parser = KaomojiParser()
        XCTAssertEqual(parser.isHalfKatakana("ﾊ"), true)
        XCTAssertEqual(parser.isHalfKatakana("レ"), false)
        XCTAssertEqual(parser.isHalfKatakana("a"), false)
    }

    func testSearch() {
        let parser = KaomojiParser()
        XCTAssertEqual(parser.search(in: "嬉しいです(≧▽≦)"), ["(≧▽≦)"])
        XCTAssertEqual(parser.search(in: "地震だ！┗(^o^;)┓"), ["┗(^o^;)┓"])
        XCTAssertEqual(parser.search(in: "またね(・Д・)ノ"), ["(・Д・)ノ"])
        XCTAssertEqual(parser.search(in: "ホームランｷﾀ━━━━(ﾟ∀ﾟ)━━━━‼︎"), ["ｷﾀ━━━━(ﾟ∀ﾟ)━━━━‼︎"])
        XCTAssertEqual(parser.search(in: "嫌い(｀ε´)　絶交しよ( ￣っ￣)"), ["(｀ε´)　", "( ￣っ￣)"])
    }

    func testRemove() {
        let parser = KaomojiParser()
        XCTAssertEqual(parser.removeKaomoji(from: "嬉しいです(≧▽≦)"), "嬉しいです")
        XCTAssertEqual(parser.removeKaomoji(from: "地震だ！┗(^o^;)┓"), "地震だ！")
        XCTAssertEqual(parser.removeKaomoji(from: "またね(・Д・)ノ"), "またね")
        XCTAssertEqual(parser.removeKaomoji(from: "ホームランｷﾀ━━━━(ﾟ∀ﾟ)━━━━‼︎"), "ホームラン")
        XCTAssertEqual(parser.removeKaomoji(from: "嫌い(｀ε´)　絶交しよ( ￣っ￣)"), "嫌い絶交しよ")
    }

}
