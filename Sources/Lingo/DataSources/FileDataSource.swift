import Foundation

/// Class providing file backed data source for Lingo in case localizations are stored in JSON files.
public final class FileDataSource: LocalizationDataSource {
    
    public let rootPath: String
    
    /// `rootPath` should contain localization files in JSON format named based on relevant locale. For example: en.json, de.json etc.
    public init(rootPath: String) {
        self.rootPath = rootPath
    }
    
    // MARK: LocalizationDataSource
    public func availableLocales() -> [LocaleIdentifier] {
        do {
            let identifiers = try FileManager().contentsOfDirectory(atPath: self.rootPath).filter {
                $0.hasSuffix(".json")
            }.map {
                $0.components(separatedBy: ".").first! // It is safe to use force unwrap here as $0 will always contain the "."
            }
            
            return identifiers

        } catch let e {
            assertionFailure("Failed retrieving contents of a directory: \(e.localizedDescription)")
            return []
        }
    }
    
    public func localizations(for locale: LocaleIdentifier) -> [LocalizationKey : Localization] {
        let jsonFilePath = "\(self.rootPath)/\(locale).json"
        
        // Try to read localizations file from disk
        guard let localizationsData = self.loadLocalizations(atPath: jsonFilePath) else {
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
    func loadLocalizations(atPath path: String) -> [String: Any]? {
        precondition(FileManager().fileExists(atPath: path))

        guard
            let fileContent = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let jsonObject = try? JSONSerialization.jsonObject(with: fileContent, options: []) as? [String: Any] else {
                assertionFailure("Failed reading localizations from file at path: \(path)")
                return nil
        }
        
        return jsonObject
    }
    
}
