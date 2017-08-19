import Foundation

class OneUptoTwoOther: AbstractPluralizationRule {
    
    let availablePluralCategories: [PluralCategory] = [.one, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        return n >= 0 && n < 2 ? .one : .other
    }
    
}
