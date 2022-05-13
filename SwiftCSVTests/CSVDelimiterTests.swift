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
        XCTAssertEqual(CSV.Delimiter.comma.rawValue, ",")
        XCTAssertEqual(CSV.Delimiter.semicolon.rawValue, ";")
        XCTAssertEqual(CSV.Delimiter.tab.rawValue, "\t")
        XCTAssertEqual(CSV.Delimiter.character("x").rawValue, "x")
    }

    func testLiteralInitializer() {
        XCTAssertEqual(CSV.Delimiter.comma, ",")
        XCTAssertEqual(CSV.Delimiter.semicolon, ";")
        XCTAssertEqual(CSV.Delimiter.tab, "\t")
        XCTAssertEqual(CSV.Delimiter.character("x"), "x")
    }
}
