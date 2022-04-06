import Foundation

final class lv: PluralizationRule {

    let locale: LocaleIdentifier = "lv"
    
    let availablePluralCategories: [PluralCategory] = [.one, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n % 10 == 1 && n % 100 != 11 {
            return .one
            
        } else {
            return .other
        }
    }

}
