import Foundation

final class mk: PluralizationRule {
    
    let locale: LocaleIdentifier = "mk"
    
    let availablePluralCategories: [PluralCategory] = [.one, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n % 10 == 1 && n != 11 {
            return .one
            
        } else {
            return .other
        }
    }
    
}
