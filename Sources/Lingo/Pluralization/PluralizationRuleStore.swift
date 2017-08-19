import Foundation

struct PluralizationRuleStore {
    
    static func pluralizationRule(forLocale locale: LocaleIdentifier) -> PluralizationRule? {
        return self.allPluralizationRulesMap[locale]
    }
    
    static func availablePluralCategories(forLocale locale: LocaleIdentifier) -> [PluralCategory] {
        return self.allPluralizationRulesMap[locale]?.availablePluralCategories ?? []
    }
        
}

fileprivate extension PluralizationRuleStore {
    
    /// Returns a map of all LocaleIdentifiers to it's PluralizationRules for a faster access
    static let allPluralizationRulesMap: [LocaleIdentifier: PluralizationRule] = {
        var rulesMap = [LocaleIdentifier: PluralizationRule]()
        for rule in PluralizationRuleStore.all {
            rulesMap[rule.locale] = rule
        }
        return rulesMap
    }()

}
