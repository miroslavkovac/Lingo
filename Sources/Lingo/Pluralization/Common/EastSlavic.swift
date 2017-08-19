import Foundation

/// Used for Belarusian, Bosnian, Croatian, Russian, Serbian, Ukrainian.
class EastSlavic: AbstractPluralizationRule {
    
    let availablePluralCategories: [PluralCategory] = [.one, .few, .many, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        let mod10 = n % 10
        let mod100 = n % 100
        
        if mod10 == 1 && mod100 != 11 {
            return .one
        }
        
        if (2...4).contains(mod10) && !(12...14).contains(mod100) {
            return .few
        }
        
        if mod10 == 0 || (5...9).contains(mod10) || (12...14).contains(mod100) {
            return .many
        }
        
        return .other
    }
    
}
