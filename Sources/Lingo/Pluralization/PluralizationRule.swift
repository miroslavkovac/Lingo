import Foundation

protocol AbstractPluralizationRule {
    
    /// Returns matching `PluralCategory` for given numeric value.
    /// http://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html
    func pluralCategory(forNumericValue: UInt) -> PluralCategory
    
    /// Returns a list of all available PluralCategories
    var availablePluralCategories: [PluralCategory] { get }

}

protocol LocaleIdentifiable {
    
    var locale: LocaleIdentifier { get }
    
}

protocol PluralizationRule: AbstractPluralizationRule, LocaleIdentifiable { }
