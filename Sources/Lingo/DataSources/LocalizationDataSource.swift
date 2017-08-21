import Foundation

/// Types conforming to this protocol can be used to initialize Lingo.
///
/// Use it in case your localizations are not stored in JSON files, but rather in a database or other storage technology.
public protocol LocalizationDataSource {
    
    func availableLocales() -> [LocaleIdentifier]
    
    func localizations(`for` locale: LocaleIdentifier) -> [LocalizationKey: Localization]
    
}
