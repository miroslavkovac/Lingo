import Foundation

/// Class providing file backed data source for Lingo in case localizations are stored in JSON files.
public final class FileDataSource: DataSource {
    
    public let rootPath: String
    
    /// `rootPath` should contain localization files in JSON format named based on relevant locale. For example: en.json, de.json etc.
    public init(rootPath: String) throws {
        self.rootPath = rootPath
    }
    
    // MARK: DataSource
    public func availableLocales() throws -> [LocaleIdentifier] {
        return try FileManager().contentsOfDirectory(atPath: self.rootPath).filter {
            $0.hasSuffix(".json")
        }.map {
            $0.components(separatedBy: ".").first! // It is safe to use force unwrap here as $0 will always contain the "."
        }
    }
    
    public func localizations(for locale: LocaleIdentifier) throws -> [LocalizationKey : Localization] {
        let jsonFilePath = "\(self.rootPath)/\(locale).json"
        
        // Try to read localizations file from disk
        guard let localizationsData = try self.loadLocalizations(atPath: jsonFilePath) else {
            assertionFailure("Failed to load localizations at path: \(jsonFilePath)")
            return [:]
        }
        
        var localizations = [LocalizationKey: Localization]()
        
        // Parse localizations. Note that localizationObject can be:
        // - a string, in case there are no different pluralizations defined (one, few, many, other,..)
        // - an object, in case pluralization is used
        for (localizationKey, object) in localizationsData {
            if let stringValue = object as? String {
                let localization = Localization.universal(value: stringValue)
                localizations[localizationKey] = localization
                
            } else if let rawPluralizedValues = object as? [String: String] {
                let pluralizedValues = self.pluralizedValues(fromRaw: rawPluralizedValues)
                let localization = Localization.pluralized(values: pluralizedValues)
                localizations[localizationKey] = localization
                
            } else {
                assertionFailure("Unsupported localization format for key: \(localizationKey). Localization key will be skipped.")
            }
        }
        
        return localizations
    }
    
}

fileprivate extension FileDataSource {
    
    /// Parses a dictionary which has string plural categories as keys ([String: String]) and returns a typed dictionary ([PluralCategory: String])
    /// An example dictionary looks like:
    /// {
    ///   "one": "You have an unread message."
    ///   "many": "You have %{count} unread messages."
    /// }
    func pluralizedValues(fromRaw rawPluralizedValues: [String: String]) -> [PluralCategory: String] {
        var pluralizedValues = [PluralCategory: String]()
        
        for (rawPluralCategory, value) in rawPluralizedValues {
            guard let pluralCategory = PluralCategory(rawValue: rawPluralCategory) else {
                assertionFailure("Unsupported plural category: \(rawPluralCategory)")
                continue
            }
            pluralizedValues[pluralCategory] = value
        }
        
        return pluralizedValues
    }
    
    /// Loads a localizations file from disk if it exists and parses it.
    /// It can throw an exception in case JSON file is invalid.
    func loadLocalizations(atPath path: String) throws -> [String: Any]? {
        if !FileManager().fileExists(atPath: path) {
            return nil
        }
        
        let fileContent = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONSerialization.jsonObject(with: fileContent, options: []) as? [String: Any]
    }
    
}
