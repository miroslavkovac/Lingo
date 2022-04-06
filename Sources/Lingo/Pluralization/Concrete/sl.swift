import Foundation

final class sl: PluralizationRule {

    let locale: LocaleIdentifier = "sl"

    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        let mod100 = n % 100
        
        if mod100 == 1 {
            return .one
            
        } else if mod100 == 2 {
            return .two
            
        } else if mod100 == 3 || mod100 == 4 {
            return .few
            
        } else {
            return .other
        }
        
    }
    
    let availablePluralCategories: [PluralCategory] = [.one, .two, .few, .other]
    
}
