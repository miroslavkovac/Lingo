import Foundation

public typealias LocalizationKey = String
public typealias LocaleIdentifier = String

public final class Lingo {
    
    public let defaultLocale: LocaleIdentifier
    public let dataSource: LocalizationDataSource
    
    private let model: LocalizationsModel
    
    /// Convenience initializer for Lingo.
    ///
    /// - `rootPath` should contain localization files in JSON format
    /// named based on relevant locale. For example: en.json, de.json etc.
    /// - `defaultLocale` will be used as a fallback when no localizations are available for a requested locale.
    public convenience init(rootPath: String, defaultLocale: LocaleIdentifier) throws {
        let dataSource = FileDataSource(rootPath: rootPath)
        try self.init(dataSource: dataSource, defaultLocale: defaultLocale)
    }
    
    /// Initializes Lingo with a `LocalizationDataSource`.
    /// - `defaultLocale` will be used as a fallback when no localizations are available for a requested locale.
    public init(dataSource: LocalizationDataSource, defaultLocale: LocaleIdentifier) throws {
        self.dataSource = dataSource
        self.defaultLocale = defaultLocale
        self.model = LocalizationsModel()
        
        let validator = LocaleValidator()

        for locale in try dataSource.availableLocales() {
            // Check if locale is valid. Invalid locales will not cause any problems in the runtime,
            // so this validation should only warn about potential mistype in locale names.
            if !validator.validate(locale: locale) {
                print("WARNING: Invalid locale identifier: \(locale)")
            }

            let localizations = try dataSource.localizations(forLocale: locale)
            self.model.addLocalizations(localizations, for: locale)
        }
    }
    
    /// Returns localized string for the given key in the requested locale.
    /// If string contains interpolations, they are replaced from the `interpolations` dictionary.
    public func localize(_ key: LocalizationKey, locale: LocaleIdentifier, interpolations: [String: Any]? = nil) -> String {
        let result = self.model.localize(key, locale: locale, interpolations: interpolations)
        switch result {
            case .success(let localizedString):
                return localizedString

            case .missingKey:
                let defaultLocaleResult = self.model.localize(key, locale: self.defaultLocale, interpolations: interpolations)
                guard case LocalizationsModel.LocalizationResult.success(let localizationInDefaultLocale) = defaultLocaleResult else {
                    print("No localizations found for key: \(key), locale: \(locale) or in default locale. Will fallback to raw value of the key.")
                    return key
                }
                return localizationInDefaultLocale
            
            case .missingLocale:
                // Fallback to default locale
                let defaultLocaleResult = self.model.localize(key, locale: self.defaultLocale, interpolations: interpolations)
                guard case LocalizationsModel.LocalizationResult.success(let localizationInDefaultLocale) = defaultLocaleResult else {
                    print("Missing localization for key: \(key), locale: \(locale). Will fallback to raw value of the key.")
                    return key
                }
                
                return localizationInDefaultLocale
        }
    }
 
    /// Returns a list of all available PluralCategories for locale
    public static func availablePluralCategories(forLocale locale: LocaleIdentifier) -> [PluralCategory] {
        return PluralizationRuleStore.availablePluralCategories(forLocale: locale)
    }
    
}
