#if os(Linux)

import XCTest
@testable import LingoTests

extension LingoTests {
    static var allTests = [
        ("testNonExistingKeyReturnsRawKeyAsLocalization", testNonExistingKeyReturnsRawKeyAsLocalization),
        ("testFallbackToDefaultLocale", testFallbackToDefaultLocale),
        ("testLocalization", testLocalization),
    ]
}

extension enTests {
    static var allTests = [
        ("testPluralCategory", testPluralCategory),
    ]
}

extension deTests {
    static var allTests = [
        ("testPluralCategory", testPluralCategory),
    ]
}

XCTMain([
    testCase(LingoTests.allTests),
    testCase(enTests.allTests),
    testCase(deTests.allTests),
])

#endif
