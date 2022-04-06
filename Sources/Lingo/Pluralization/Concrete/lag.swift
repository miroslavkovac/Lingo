import Foundation

final class lag: PluralizationRule {

    let locale: LocaleIdentifier = "lag"
    
    var availablePluralCategories: [PluralCategory] = [.zero, .one, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if n == 0 {
            return .zero
            
        } else if n > 0 && n < 2 {
            return .one
            
        } else {
            return .other
        }
    }

}
