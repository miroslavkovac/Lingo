import Foundation

class LocaleValidator {
    
    private static let validLocaleIdentifiers = Set(Locale.availableIdentifiers)
    
    /// Checks if given locale is present in Locale.availableIdentifiers
    func validate(locale: LocaleIdentifier) -> Bool {
        return LocaleValidator.validLocaleIdentifiers.contains(locale)
    }
    
}
