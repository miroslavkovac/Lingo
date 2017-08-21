import Foundation

class LocalizationsModel {
    
    enum LocalizationResult {
        case success(localization: String)
        case missingLocale
        case missingKey
    }
    
    private var data = [LocaleIdentifier: [LocalizationKey: Localization]]()
    
    /// Adds localization for a given key and locale. If localization for a given key already exists, it will be overwritten
    func addLocalization(_ localization: Localization, forKey key: LocalizationKey, locale: LocaleIdentifier) {
        // Find existing bucket for a given locale or create a new one
        var localeBucket = self.data[locale] ?? [LocalizationKey: Localization]()
        
        // Update the data
        localeBucket[key] = localization
        self.data[locale] = localeBucket
    }
    
    func addLocalizations(_ localizations: [LocalizationKey: Localization], `for` locale: LocaleIdentifier) {
        // Find existing bucket for a given locale or create a new one
        if var existingLocaleBucket = self.data[locale] {
            for (localiationKey, localization) in localizations {
                existingLocaleBucket[localiationKey] = localization
                self.data[locale] = existingLocaleBucket
            }
        } else {
            self.data[locale] = localizations
        }
    }
    
    /// Returns localized string of a given key in the given locale.
    /// If string contains interpolations, they are replaced from the dictionary.
    func localized(key: LocalizationKey, locale: LocaleIdentifier, interpolations: [String: Any]? = nil) -> LocalizationResult {
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
