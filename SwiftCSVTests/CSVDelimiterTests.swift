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
        XCTAssertEqual(Delimiter.comma.rawValue, ",")
        XCTAssertEqual(Delimiter.semicolon.rawValue, ";")
        XCTAssertEqual(Delimiter.tab.rawValue, "\t")
        XCTAssertEqual(Delimiter.character("x").rawValue, "x")
    }

    func testLiteralInitializer() {
        XCTAssertEqual(Delimiter.comma, ",")
        XCTAssertEqual(Delimiter.semicolon, ";")
        XCTAssertEqual(Delimiter.tab, "\t")
        XCTAssertEqual(Delimiter.character("x"), "x")
    }
}
