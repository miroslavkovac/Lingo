import XCTest
@testable import Lingo

final class LocaleValidatorTests: XCTestCase {

    private let validator = LocaleValidator()

    func testValidLocales() {
        XCTAssertTrue(self.validator.validate(locale: "en"))
        XCTAssertTrue(self.validator.validate(locale: "en-GB"))
        XCTAssertTrue(self.validator.validate(locale: "en-US"))

        XCTAssertTrue(self.validator.validate(locale: "de"))
        XCTAssertTrue(self.validator.validate(locale: "de-CH"))
        XCTAssertTrue(self.validator.validate(locale: "de-AT"))
    }

    func testInvalidLocales() {
        XCTAssertFalse(self.validator.validate(locale: ""))
        XCTAssertFalse(self.validator.validate(locale: "xx"))
        XCTAssertFalse(self.validator.validate(locale: "123"))

        XCTAssertFalse(self.validator.validate(locale: "en_GB"))
        XCTAssertFalse(self.validator.validate(locale: "en_US"))

        XCTAssertFalse(self.validator.validate(locale: "de_CH"))
        XCTAssertFalse(self.validator.validate(locale: "de_AT"))

        XCTAssertFalse(self.validator.validate(locale: "en_gb"))
        XCTAssertFalse(self.validator.validate(locale: "en_us"))
    }

    func testAllIncludedLocalesAreValid() {
        PluralizationRuleStore.all.forEach { pluralizationRule in
            if !self.validator.validate(locale: pluralizationRule.locale) {
                print(pluralizationRule.locale)
            }
//            XCTAssertTrue(self.validator.validate(locale: pluralizationRule.locale))
        }
    }

}
