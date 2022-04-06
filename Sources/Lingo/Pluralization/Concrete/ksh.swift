import Foundation

final class ksh: PluralizationRule {

    let locale: LocaleIdentifier = "ksh"

    let availablePluralCategories: [PluralCategory] = [.zero, .one, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n == 0 {
            return .zero
            
        } else if n == 1 {
            return .one
            
        } else {
            return .other
        }
    }
    
}
