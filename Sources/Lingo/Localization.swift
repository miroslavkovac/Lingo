import Foundation

/// Object represents localization of a given key in a given language.
///
/// It has 2 cases:
/// - `universal` - in case pluralization is not needed and one value is used for all plural categories
/// - `pluralized` - in case of different localizations are defined based on a PluralCategory
public enum Localization {
    
    case universal(value: String)
    case pluralized(values: [PluralCategory: String])
    
    func value(forLocale locale: LocaleIdentifier, interpolations: [String: Any]? = nil) -> String {
        switch self {
            case .universal(let rawString):
                return self.interpolate(rawString, interpolations: interpolations)
            
            case .pluralized(let values):
                let pluralCategory = self.pluralCategory(for: locale, interpolations: interpolations)
                guard let rawString = values[pluralCategory] else {
                    print("Missing plural value for category: \(pluralCategory). Will default to an empty string.")
                    return ""
                }
                
                return self.interpolate(rawString, interpolations: interpolations)
        }
    }
    
}

private extension Localization {
    
    static let interpolator = StringInterpolator()

    /// Returns string by interpolating rawString with passed interpolations
    func interpolate(_ rawString: String, interpolations: [String: Any]?) -> String {
        guard let interpolations = interpolations else {
            return rawString
        }
        
        return Localization.interpolator.interpolate(rawString, with: interpolations)
    }
    
    /// The PluralCategory is based on the first numeric value in `interpolations` and `PluralizationRule` for the given language.
    /// If no numeric value is found, it fallbacks to `.other`.
    func pluralCategory(`for` locale: LocaleIdentifier, interpolations: [String: Any]?) -> PluralCategory {
        // If there are no interpolations, or there is not a single numeric value in them,
        // there is no way to determine which plural category to use, so default to .other
        guard let interpolations = interpolations, let numericValue = self.extractNumericValue(from: interpolations) else {
            return .other
        }
        
        // If no pluralization rule is defined for current language, default to .other.
        guard let pluralizationRule = PluralizationRuleStore.pluralizationRule(forLocale: locale) else {
            print("Missing pluralization rule for locale: \(locale). Will default to `other` rule.")
            return .other
        }
        
        return pluralizationRule.pluralCategory(forNumericValue: numericValue)
    }
    
    /// Extract the first numeric value from the interpolations and make it non negative.
    /// Currently we do not support localizations with more than one plural category (example: you have 1 unread message and 6 unread emails.),
    /// so the first numerical value that is found will be used for pluralization rules.
    func extractNumericValue(from interpolations: [String: Any]) -> UInt? {
        for value in interpolations.values {
            if var intValue = value as? Int {
                // Make sure the value is always positive
                if intValue < 0 {
                    intValue *= -1
                }
                
                return UInt(intValue)
            }
        }
        
        return nil
    }
    
}
