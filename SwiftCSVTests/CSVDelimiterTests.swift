//
//  CSVDelimiterTests.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 21.12.21.
//  Copyright © 2021 SwiftCSV. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class CSVDelimiterTests: XCTestCase {
    func testRawValue() {
        XCTAssertEqual(CSVDelimiter.comma.rawValue, ",")
        XCTAssertEqual(CSVDelimiter.semicolon.rawValue, ";")
        XCTAssertEqual(CSVDelimiter.tab.rawValue, "\t")
        XCTAssertEqual(CSVDelimiter.character("x").rawValue, "x")
    }

    func testLiteralInitializer() {
        XCTAssertEqual(CSVDelimiter.comma, ",")
        XCTAssertEqual(CSVDelimiter.semicolon, ";")
        XCTAssertEqual(CSVDelimiter.tab, "\t")
        XCTAssertEqual(CSVDelimiter.character("x"), "x")
    }
}
