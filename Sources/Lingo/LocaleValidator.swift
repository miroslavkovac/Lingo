import Foundation

class LocaleValidator {
    
    // On Linux `Locale.availableIdentifiers` throws an exception.
    // Issue reported: https://bugs.swift.org/browse/SR-3634
    // Pull request with fix: https://github.com/apple/swift-corelibs-foundation/pull/944
    // This check can be removed when the changes are available in a new Swift version.
    #if os(Linux)
        private static let validLocaleIdentifiers = Set<String>()
    #else
        private static let validLocaleIdentifiers = Set(Locale.availableIdentifiers)
    #endif

    /// Checks if given locale is present in Locale.availableIdentifiers
    func validate(locale: LocaleIdentifier) -> Bool {
        return LocaleValidator.validLocaleIdentifiers.contains(locale)
    }
    
}
