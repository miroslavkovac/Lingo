import Foundation

final class LocalizationsModel {
    
    enum LocalizationResult {
        case success(localization: String)
        case missingLocale
        case missingKey
    }
    
    private var data = [LocaleIdentifier: [LocalizationKey: Localization]]()
        
    func addLocalizations(_ localizations: [LocalizationKey: Localization], `for` locale: LocaleIdentifier) {
        // Find existing bucket for a given locale or create a new one
        if var existingLocaleBucket = self.data[locale] {
            for (localizationKey, localization) in localizations {
                existingLocaleBucket[localizationKey] = localization
                self.data[locale] = existingLocaleBucket
            }
        } else {
            self.data[locale] = localizations
        }
    }
    
    /// Returns localized string of a given key in the given locale.
    /// If string contains interpolations, they are replaced from the dictionary.
    func localize(_ key: LocalizationKey, locale: LocaleIdentifier, interpolations: [String: Any]? = nil) -> LocalizationResult {
        guard let localeBucket = self.data[locale] else {
            return .missingLocale
        }
        
        guard let localization = localeBucket[key] else {
            return .missingKey
        }
        
        let localizedString = localization.value(forLocale: locale, interpolations: interpolations)
        return .success(localization: localizedString)
    }

}
