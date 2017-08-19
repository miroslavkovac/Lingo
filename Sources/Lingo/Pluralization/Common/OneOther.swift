import Foundation

class OneOther: AbstractPluralizationRule {
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        return n == 1 ? .one : .other
    }
    
    let availablePluralCategories: [PluralCategory] = [.one, .other]
    
}
