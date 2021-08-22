import Foundation

public struct KaomojiParser {
    func isKaomojiMainCharacter(_ unicodeScalar: UnicodeScalar) -> Bool {
        if CharacterSet.punctuationCharacters.contains(unicodeScalar){
            return true
        }
        if CharacterSet.symbols.contains(unicodeScalar){
            return true
        }
        return !isJapanese(unicodeScalar)
    }

    func isJapanese(_ unicodeScalar: UnicodeScalar) -> Bool {
        let value = unicodeScalar.value
        if 0x0000...0x007F ~= value{
            return true
        }
        if 0xFF61...0xFF9F ~= value{
            return true
        }
        if 0x4E00...0x9FFF ~= value{
            return true
        }
        if 0x3041...0x309F ~= value{
            return true
        }
        if 0x30A0...0x30FF ~= value{
            return true
        }
        if 0xFF01...0xFF60 ~= value{
            return true
        }
        return false
    }

    func shouldBeDroppedLeft(_ unicodeScalar: UnicodeScalar) -> Bool {
        let charcterSet = CharacterSet(charactersIn: ")）」』］】｝〉〕。、,.!?！？…→")
        if charcterSet.contains(unicodeScalar){
            return true
        }
        return false
    }

    func shouldBeDroppedRight(_ unicodeScalar: UnicodeScalar) -> Bool {
        let charcterSet = CharacterSet(charactersIn: "(（「『［【｛〈〔。、,.!?！？…←")
        if charcterSet.contains(unicodeScalar){
            return true
        }
        return false
    }

    func isPermittedLeftSequence(_ unicodeScalars: [UnicodeScalar]) -> Bool {
        let list: [[UnicodeScalar]] = [
            ["m","("],
            ["(","("],
            ["ヽ","("],
            ["ヾ","("],
            ["o","("],
            [".","°"],
            ["。","・"],
            ["ヾ","ﾉ"],
            [" ","ﾉ"],
            ["ｷ","ﾀ"],
            ["ｲ","ｴ"],
        ]
        return list.contains(unicodeScalars)
    }

    func isPermittedRightSequence(_ unicodeScalars: [UnicodeScalar]) -> Bool {
        let list: [[UnicodeScalar]] = [
            [")",")"],
            [")","m"],
            [")","ﾉ"],
            [")","ノ"],
            ["`","A"],
            [";",")"],
            [")","o"],
            ["°","."],
            ["・","。"],
            ["=","3"],
        ]
        return list.contains(unicodeScalars)
    }

    func judge(_ unicodeScalars: [UnicodeScalar], L: Int) -> Bool {
        if unicodeScalars.count <= L{
            return false
        }
        let first = unicodeScalars.first!
        let last = unicodeScalars.last!
        if first == "「" && last == "」"{
            return false
        }
        if first == "『" && last == "』"{
            return false
        }
        if first == "”" && last == "”"{
            return false
        }
        if first == "”" && last == "”"{
            return false
        }
        if first == "\"" && last == "\""{
            return false
        }
        if first == "(" && last == ")"{
            let middle = unicodeScalars.dropLast().dropFirst()
            //数値
            if middle.allSatisfy({0x0030...0x0039 ~= $0.value}){
                return false
            }
            //漢字
            if middle.allSatisfy({0x4E00...0x9FFF ~= $0.value}){
                return false
            }
        }
        let filtered = unicodeScalars.filter{scalar in
            let category = scalar.properties.generalCategory
            return [.decimalNumber, .letterNumber, .uppercaseLetter, .lowercaseLetter, .otherLetter, .titlecaseLetter, .modifierLetter, .otherNumber].contains(category)
        }
        if Double(filtered.count) / Double(unicodeScalars.count) > 0.5{
            return false
        }
        return true
    }

    func kaomojiExtract(from text: String, G: Int, L: Int) -> Set<String> {
        let adjusted = text.replacingOccurrences(of: "\n", with: "     ")
        let unicodeSequence = Array(adjusted.unicodeScalars)
        var results: Set<String> = []
        var i = 0
        while true{
            if unicodeSequence.endIndex == i{
                break
            }
            if isKaomojiMainCharacter(unicodeSequence[i]){
                let (start, end) = extracting(from: unicodeSequence, center: i, G: G)
                if end <= i || start == end{
                    i += 1
                    continue
                }
                if judge(Array(unicodeSequence[start..<end]), L: L){
                    let kaomoji = unicodeSequence[start..<end].map{String($0)}.joined()
                    results.insert(kaomoji)
                    i = end
                    continue
                }
            }
            i += 1
        }

        results = results.filter{
            if Set($0).count <= L{
                return false
            }
            let first = $0.first!
            let last = $0.last!
            if first == "「" && last == "」"{
                return false
            }
            if first == "『" && last == "』"{
                return false
            }
            if first == "”" && last == "”"{
                return false
            }
            if first == "”" && last == "”"{
                return false
            }
            if first == "\"" && last == "\""{
                return false
            }
            if first == "(" && last == ")"{
                let middle = $0.dropLast().dropFirst()
                if middle.allSatisfy({$0.isNumber}){
                    return false
                }
                if middle.unicodeScalars.allSatisfy({0x4E00...0x9FFF ~= $0.value}){
                    return false
                }
            }
            let scalars = $0.unicodeScalars
            let filtered = scalars.filter{scalar in
                let category = scalar.properties.generalCategory
                return [.decimalNumber, .letterNumber, .uppercaseLetter, .lowercaseLetter, .otherLetter, .titlecaseLetter, .modifierLetter, .otherNumber].contains(category)
            }
            if Double(filtered.count) / Double(scalars.count) > 0.5{
                return false
            }
            return true
        }
        return results
    }

    func extracting(from scalars: [UnicodeScalar], center: Int, G: Int) -> (start: Int, end: Int) {
        var result = scalars[center...center]
        //領域拡大
        while true{
            var changed = false
            if let i = (max(0, result.startIndex - G) ..< result.startIndex).first{isKaomojiMainCharacter(scalars[$0])}{
                if result.startIndex != i{
                    changed = true
                }
                result = scalars[i..<result.endIndex]
            }
            if let i = (result.endIndex..<min(scalars.endIndex, result.endIndex + G)).last{isKaomojiMainCharacter(scalars[$0])}{
                if result.endIndex != i+1{
                    changed = true
                }
                result = scalars[result.startIndex..<i+1]
            }
            if !changed{
                break
            }
        }
        //領域縮小
        while result.count != 0 && shouldBeDroppedLeft(result[result.startIndex]){
            result = scalars[result.startIndex + 1 ..< result.endIndex]
        }
        while result.count != 0 && shouldBeDroppedRight(result[result.endIndex - 1]){
            result = scalars[result.startIndex ..< result.endIndex - 1]
        }
        //領域補完
        do{
            let leftside = Array(scalars[max(0, result.startIndex - 1)..<min(result.startIndex+1, result.endIndex)])
            if isPermittedLeftSequence(leftside){
                result = scalars[max(0, result.startIndex - 1) ..< result.endIndex]
            }
        }
        do{
            let rightside = Array(scalars[max(result.startIndex, result.endIndex-1)..<min(scalars.endIndex, result.endIndex + 1)])
            if isPermittedRightSequence(rightside){
                result = scalars[result.startIndex ..< min(scalars.endIndex, result.endIndex + 1)]
            }
        }
        return (result.startIndex, result.endIndex)
    }

    public func search(from string: String, G: Int, L: Int) -> Set<String> {
        let splited = string.split(separator: "\n")
        let result = splited.flatMap{kaomojiExtract(from: String($0), G: G, L: L)}
        return Set(result)
    }
}
