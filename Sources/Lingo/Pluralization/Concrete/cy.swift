import Foundation

final class cy: PluralizationRule {

    let locale: LocaleIdentifier = "cy"

    let availablePluralCategories: [PluralCategory] = [.zero, .one, .two, .few, .many, .other]
    
    func pluralCategory(forNumericValue n: UInt) -> PluralCategory {
        switch n {
            case 0: return .zero
            case 1: return .one
            case 2: return .two
            case 3: return .few
            case 6: return .many
            default: return .other
        }
    }
    
}
