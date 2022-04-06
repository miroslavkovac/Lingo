import Foundation

final class ga: PluralizationRule {
    
    let locale: LocaleIdentifier = "ga"
    
    let availablePluralCategories: [PluralCategory] = [.one, .two, .few, .many, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n == 1 {
            return .one
            
        } else if n == 2 {
            return .two
            
        } else if (3...6).contains(n) {
            return .few
            
        } else if (7...10).contains(n) {
            return .many
            
        } else {
            return .other
        }
    }
    
}
