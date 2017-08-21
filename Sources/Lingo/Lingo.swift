import Foundation

public typealias LocalizationKey = String
public typealias LocaleIdentifier = String

public final class Lingo {
    
    public let defaultLocale: LocaleIdentifier?
    
    private let model: LocalizationsModel
    
    /// Convenience initializer for Lingo. `rootPath` should contain localization files in JSON format
    /// named based on relevant locale. For example: en.json, de.json etc.
    ///
    /// If the `defaultLocale` is specified, it will be used as a fallback when no localizations
    /// are available for given locale.
    public convenience init(rootPath: String, defaultLocale: LocaleIdentifier?) {
        let dataSource = FileDataSource(rootPath: rootPath)
        self.init(dataSource: dataSource, defaultLocale: defaultLocale)
    }
    
    /// Initializes Lingo with a `LocalizationDataSource`.
    ///
    /// If the `defaultLocale` is specified, it will be used as a fallback when no localizations
    /// are available for given locale.
    public init(dataSource: LocalizationDataSource, defaultLocale: LocaleIdentifier?) {
        self.defaultLocale = defaultLocale
        self.model = LocalizationsModel()
        
        let validator = LocaleValidator()

        for locale in dataSource.availableLocales() {
            // Check if locale is valid. Invalid locales will not cause any problems in the runtime,
            // so this validation should only warn about potential mistype in locale names.
            if !validator.validate(locale: locale) {
                print("WARNING: Invalid locale identifier: \(locale)")
            }

            let localizations = dataSource.localizations(for: locale)
            self.model.addLocalizations(localizations, for: locale)
        }
    }
    
    /// Returns localized string for given key in specified locale.
    /// If string contains interpolations, they are replaced from the `interpolations` dictionary.
    public func localize(_ key: LocalizationKey, locale: LocaleIdentifier, interpolations: [String: Any]? = nil) -> String {
        let result = self.model.localize(key, locale: locale, interpolations: interpolations)
        switch result {
            case .missingKey:
                print("Missing localization for locale: \(locale)")
                return key
            
            case .missingLocale:
                if let defaultLocale = self.defaultLocale {
                    return self.localize(key, locale: defaultLocale, interpolations: interpolations)
                } else {
                    print("Missing \(locale) localization for key: \(key)")
                    return key
            }

            case .success(let localizedString):
                return localizedString
        }
    }
 
    /// Returns a list of all available PluralCategories for a given locale
    public static func availablePluralCategories(forLocale locale: LocaleIdentifier) -> [PluralCategory] {
        return PluralizationRuleStore.availablePluralCategories(forLocale: locale)
    }
    
}
