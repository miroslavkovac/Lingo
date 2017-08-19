import Foundation

/// Used for Cornish, Inari Sami, Inuktitut, Lule Sami, Nama, Northern Sami, Skolt Sami, Southern Sami
class OneTwoOther: AbstractPluralizationRule {
    
    let availablePluralCategories: [PluralCategory] = [.one, .two, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n == 1 {
            return .one
        }
        
        if n == 2 {
            return .two
        }
        
        return .other
    }
    
}
