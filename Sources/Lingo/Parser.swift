import Foundation

class Parser {
    
    let rootURL: URL
    
    init(rootURL: URL) {
        self.rootURL = rootURL
    }
    
    /// Parses all available localization files located under `rootPath` and returns in memory representation of them.
    func parse() throws -> LocalizationsModel {
        let model = LocalizationsModel()
        let validator = LocaleValidator()
        
        for path in try self.availableLocalizationFilePaths() {
            // Extract locale as file name without an extension.
            // It is safe to force unwrap here, because all of these paths have .json extension
            let locale: LocaleIdentifier = URL(fileURLWithPath: path).fileNameWithoutExtension!
            
            // Check if locale is valid. Invalid locales will not cause any problems in the runtime,
            // so this validation should only warn about potential mistype in localization file names
            if !validator.validate(locale: locale) {
                print("WARNING: Invalid locale identifier: \(locale)")
            }
            
            // Try to read localizations file from disk
            guard let localizationsData = try self.loadLocalizations(atPath: path) else {
                assertionFailure("Failed to load localizations at path: \(path)")
                continue
            }

            // Import localizations. Note that localizationObject can be:
            // - a string, in case there are no different pluralizations defined (one, few, many, other,..)
            // - an object, in case pluralization is used
            for (localizationKey, object) in localizationsData {
                if let stringValue = object as? String {
                    let localization = Localization.universal(value: stringValue)
                    model.addLocalization(localization, forKey: localizationKey, locale: locale)

                } else if let rawPluralizedValues = object as? [String: String] {
                    let pluralizedValues = self.parsePluralizedValues(rawPluralizedValues)
                    let localization = Localization.pluralized(values: pluralizedValues)
                    model.addLocalization(localization, forKey: localizationKey, locale: locale)

                } else {
                    assertionFailure("Unsupported localization format for key: \(localizationKey). Localization key will be skipped.")
                }
            }
        }
        
        return model
    }
    
}

fileprivate extension Parser {
    
    func availableLocalizationFilePaths() throws -> [String] {
        let jsonSubpaths = try FileManager().contentsOfDirectory(atPath: self.rootURL.path).filter {
            $0.hasSuffix(".json")
        }
        
        return jsonSubpaths.map { "\(self.rootURL.path)/\($0)" }
    }
    
    /// Parses a dictionary which has string plural categories as keys ([String: String]) and returns a typed dictionary ([PluralCategory: String])
    /// An example dictionary looks like:
    /// {
    ///   "one": "You have an unread message."
    ///   "many": "You have %{count} unread messages."
    /// }
    func parsePluralizedValues(_ rawPluralizedValues: [String: String]) -> [PluralCategory: String] {
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

fileprivate extension URL {
    
    /// Returns file name without file extension or nil if URL is not file URL.
    var fileNameWithoutExtension: String? {
        guard self.isFileURL else {
            return nil
        }
        
        // If file does not have an extension return it full
        if self.lastPathComponent.range(of: ".") == nil {
            return self.lastPathComponent
        }
        
        // Return the substring before the first .
        return self.lastPathComponent.components(separatedBy: ".").first
    }
    
}
