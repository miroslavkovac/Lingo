import XCTest
@testable import Lingo

class LingoTests: XCTestCase {
    
    let localizationsRootPath = NSTemporaryDirectory().appending("LingoTests")
    
    override func setUp() {
        super.setUp()
        try! DefaultFixtures.setup(atPath: self.localizationsRootPath) // swiftlint:disable:this force_try
    }
    
    func testNonExistingKeyReturnsRawKeyAsLocalization() throws {
        let lingo = try Lingo(rootURL: URL(fileURLWithPath: self.localizationsRootPath), defaultLocale: nil)
        XCTAssertEqual(lingo.localized("non.existing.key", locale: "en"), "non.existing.key")
    }
    
    func testNonExistingLocaleReturnsRawKeyAsLocalizationWhenDefaultLocaleIsNotSpecified() throws {
        let lingo = try Lingo(rootURL: URL(fileURLWithPath: self.localizationsRootPath), defaultLocale: nil)
        XCTAssertEqual(lingo.localized("hello.world", locale: "non-existing-locale"), "hello.world")
    }
    
    func testFallbackToDefaultLocale() throws {
        let lingo = try Lingo(rootURL: URL(fileURLWithPath: self.localizationsRootPath), defaultLocale: "en")
        XCTAssertEqual(lingo.localized("hello.world", locale: "non-existing-locale"), "Hello World!")
    }
    
    func testLocalization() throws {
        let lingo = try Lingo(rootURL: URL(fileURLWithPath: self.localizationsRootPath), defaultLocale: nil)
        
        XCTAssertEqual(lingo.localized("hello.world", locale: "en"), "Hello World!")
        XCTAssertEqual(lingo.localized("hello.world", locale: "de"), "Hallo Welt!")
        XCTAssertEqual(lingo.localized("unread.messages", locale: "en", interpolations: ["unread-messages-count": 1]), "You have an unread message.")
        XCTAssertEqual(lingo.localized("unread.messages", locale: "en", interpolations: ["unread-messages-count": 24]), "You have 24 unread messages.")
    }
    
}
