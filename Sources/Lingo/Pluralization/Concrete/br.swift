import Foundation

final class br: PluralizationRule {

    let locale: LocaleIdentifier = "br"

    let availablePluralCategories: [PluralCategory] = [.one, .two, .few, .many, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        let mod10 = n % 10
        let mod100 = n % 100
        
        if mod10 == 1 && ![11, 71, 91].contains(mod100) {
            return .one
            
        } else if mod10 == 2 && ![12, 72, 92].contains(mod100) {
            return .two
            
        } else if [3, 4, 9].contains(mod10) && !(10...19).contains(mod100) && !(70...79).contains(mod100) && !(90...99).contains(mod100) {
            return .few
            
        } else if n % 1000000 == 0 && n != 0 {
            return .many
            
        } else {
            return .other
        }
    }
    
}
