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
    public convenience init(rootPath: String, defaultLocale: LocaleIdentifier?) throws {
        let dataSource = try FileDataSource(rootPath: rootPath)
        try self.init(dataSource: dataSource, defaultLocale: defaultLocale)
    }
    
    /// Initializes Lingo. With a DataSource providing localization data
    ///
    /// If the `defaultLocale` is specified, it will be used as a fallback when no localizations
    /// are available for given locale.
    public init(dataSource: DataSource, defaultLocale: LocaleIdentifier?) throws {
        self.defaultLocale = defaultLocale
        self.model = LocalizationsModel()
        
        let validator = LocaleValidator()

        for locale in try dataSource.availableLocales() {
            // Check if locale is valid. Invalid locales will not cause any problems in the runtime,
            // so this validation should only warn about potential mistype in locale names.
            if !validator.validate(locale: locale) {
                print("WARNING: Invalid locale identifier: \(locale)")
            }

            let localizations = try dataSource.localizations(for: locale)
            self.model.addLocalizations(localizations, for: locale)
        }
    }
    
    /// Returns string localization of a given key in the given locale.
    /// If string contains interpolations, they are replaced from the dictionary.
    public func localized(_ key: LocalizationKey, locale: LocaleIdentifier, interpolations: [String: Any]? = nil) -> String {
        let result = self.model.localized(key: key, locale: locale, interpolations: interpolations)
        switch result {
            case .missingKey:
                print("Missing localization for locale: \(locale)")
                return key
            
            case .missingLocale:
                if let defaultLocale = self.defaultLocale {
                    return self.localized(key, locale: defaultLocale, interpolations: interpolations)
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
