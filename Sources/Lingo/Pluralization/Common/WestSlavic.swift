import Foundation

/// Used for Czech, Slovak.
class WestSlavic: AbstractPluralizationRule {
    
    let availablePluralCategories: [PluralCategory] = [.one, .few, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n == 1 {
            return .one
        }
        
        if (2...4).contains(n) {
            return .few
        }
        
        return .other
    }
    
}
