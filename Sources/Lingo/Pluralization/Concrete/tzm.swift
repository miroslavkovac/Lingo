import Foundation

final class tzm: PluralizationRule {

    let locale: LocaleIdentifier = "tzm"
    
    let availablePluralCategories: [PluralCategory] = [.one, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        if (0...1).contains(n) || (11...99).contains(n) {
            return .one
        } else {
            return .other
        }
    }

}
