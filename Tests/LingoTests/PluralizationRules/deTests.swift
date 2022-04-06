import XCTest
@testable import Lingo

final class deTests: XCTestCase {
    
    func testPluralCategory() {
        let rule = de()
        
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 1), PluralCategory.one)
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 2), PluralCategory.other)
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 5), PluralCategory.other)
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 10), PluralCategory.other)
        XCTAssertEqual(rule.pluralCategory(forNumericValue: 21), PluralCategory.other)
    }
    
}
