import Foundation

/// Types conforming to this protocol can be used to initialize Lingo.
///
/// Use it in case your localizations are not stored in JSON files, but rather in a database or other storage technology.
public protocol LocalizationDataSource {
    
    /// Return a list of available locales.
    /// Lingo will query for localizations for each of these locales in localizations(for:) method.
    func availableLocales() throws -> [LocaleIdentifier]
    
    /// Return localizations for a given locale.
    func localizations(`for` locale: LocaleIdentifier) throws -> [LocalizationKey: Localization]
    
}
