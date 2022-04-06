import Foundation

final class StringInterpolator {
    
    private static let regularExpression = try! NSRegularExpression(pattern: "\\%\\{[^\\}]*\\}", options: []) // swiftlint:disable:this force_try
    
    /// Input string is in format: "You have %{count} unread messages".
    /// The function finds all placeholders and replaces them with a value specified in interpolations dictionary
    func interpolate(_ rawString: String, with interpolations: [String: Any]) -> String {
        var result = rawString
        let matches = StringInterpolator.regularExpression.matches(in: rawString, options: [], range: NSRange.init(location: 0, length: rawString.count))

        for match in matches {
            let range: NSRange = match.range
            
            // Extract whole capture group string. Will contain string like: "%{count}"
            let startIndex = rawString.index(rawString.startIndex, offsetBy: range.location)
            let endIndex = rawString.index(startIndex, offsetBy: range.length)
            let matchedString = String(rawString[startIndex..<endIndex])

            // Extract the key from `matchedString`. Will contain string like: "count"
            let keyStartIndex = matchedString.index(matchedString.startIndex, offsetBy: 2)
            let keyEndIndex = matchedString.index(before: matchedString.endIndex)
            let key = String(matchedString[keyStartIndex..<keyEndIndex])

            if let interpolation = interpolations[key] {
                result = result.replacingOccurrences(of: matchedString, with: "\(interpolation)")
            }
        }
        
        return result
    }
    
}
