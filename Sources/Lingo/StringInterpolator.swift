import Foundation

final class StringInterpolator {
    
    private static let regexPattern = "\\%\\{[^\\}]*\\}"

    /// Input string is in format: "You have %{count} unread messages".
    /// The function finds all placeholders and replaces them with a value specified in interpolations dictionary
    func interpolate(_ rawString: String, with interpolations: [String: Any]) -> String {

        let ranges: [Range<String.Index>] = findRanges(in: rawString, startingFrom: rawString.startIndex)

        return ranges.reduce(into: rawString) { result, range in
            
            // Extract whole capture group string. Will contain string like: "%{count}"
            let matchedString = String(rawString[range.lowerBound..<range.upperBound])

            // Extract the key from `matchedString`. Will contain string like: "count"
            let keyStartIndex = matchedString.index(matchedString.startIndex, offsetBy: 2)
            let keyEndIndex = matchedString.index(before: matchedString.endIndex)
            let key = String(matchedString[keyStartIndex..<keyEndIndex])

            if let interpolation = interpolations[key] {
                result = result.replacingOccurrences(of: matchedString, with: "\(interpolation)")
            }

        }
    }

    func findRanges(in text: String, startingFrom start: String.Index) -> [Range<String.Index>] {
        let end = text.endIndex
        guard let range = text.range(of: Self.regexPattern, options: .regularExpression,
                                     range: start..<end) else {
            return ([])
        }
        let cursor = range.upperBound

        let recursiveResult = self.findRanges(in: text, startingFrom: cursor)

        return ([range] + recursiveResult)

    }
    
}
