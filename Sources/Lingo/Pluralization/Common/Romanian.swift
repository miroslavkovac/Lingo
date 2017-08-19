import Foundation

/// Used for Moldavian, Romanian.
class Romanian: AbstractPluralizationRule {
    
    let availablePluralCategories: [PluralCategory] = [.one, .few, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n == 1 {
            return .one
        }
        
        if n == 0 || (1...19).contains(n % 100) {
            return .few
        }
        
        return .other
    }
    
}
