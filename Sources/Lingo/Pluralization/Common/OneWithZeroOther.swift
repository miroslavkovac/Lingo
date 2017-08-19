import Foundation

class OneWithZeroOther: AbstractPluralizationRule {
    
    let availablePluralCategories: [PluralCategory] = [.one, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        return [0, 1].contains(n) ? .one : .other
    }
    
}
