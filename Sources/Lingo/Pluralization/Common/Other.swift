import Foundation

class Other: AbstractPluralizationRule {
    
    let availablePluralCategories: [PluralCategory] = [.other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        return .other
    }
    
}
