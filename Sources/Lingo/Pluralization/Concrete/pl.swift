import Foundation

final class pl: PluralizationRule {
    
    let locale: LocaleIdentifier = "pl"
    
    var availablePluralCategories: [PluralCategory] = [.one, .few, .many, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        let mod10 = n % 10
        let mod100 = n % 100
        
        if n == 1 {
            return .one
            
        } else if  (2...4).contains(mod10) && !(12...14).contains(mod100) {
            return .few
            
        } else if (0...1).contains(mod10) || (5...9).contains(mod10) || (12...14).contains(mod100) {
            return .many
            
        } else {
            return .other
        }
    }
    
}
