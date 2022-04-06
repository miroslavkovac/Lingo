import XCTest
@testable import Lingo

final class enTests: XCTestCase {
    
    func testPluralCategory() {
        let rule = en()
        
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 0), PluralCategory.other)
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 1), PluralCategory.one)
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 2), PluralCategory.other)
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 5), PluralCategory.other)
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 10), PluralCategory.other)
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 21), PluralCategory.other)
    }
    
}
