#if os(Linux)

import XCTest
@testable import SwiftCSVTests

XCTMain([
    testCase(CSVTests.allTests),
    testCase(EnumeratedViewTests.allTests),
    testCase(QuotedTests.allTests),
    testCase(TSVTests.allTests),
    testCase(URLTests.allTests),
    testCase(PerformanceTest.allTests),
])

#endif
