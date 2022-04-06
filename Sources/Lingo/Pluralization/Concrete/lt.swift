import Foundation

final class lt: PluralizationRule {
    
    let locale: LocaleIdentifier = "lt"
    
    var availablePluralCategories: [PluralCategory] = [.one, .few, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        let mod10 = n % 10
        let mod100 = n % 100
        
        if mod10 == 1 && !(11...19).contains(mod100) {
            return .one
            
        } else if (2...9).contains(mod10) && !(11...19).contains(mod100) {
            return .few
            
        } else {
            return .other
        }
    }
    
}
