//
//  CSVDelimiterGuessingTests.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 21.12.21.
//  Copyright © 2021 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class CSVDelimiterGuessingTests: XCTestCase {
    func testGuessDelimiter_InvalidInput_FallbackToComma() throws {
        XCTAssertEqual(CSVDelimiter.guessed(string: ""), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: "    "), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: "fallback"), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: #""opened;quote;never;closed"#), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: "just a single line of text"), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: "\n"), .comma)
    }

    func testGuessDelimiter_Comma() throws {
        XCTAssertEqual(CSVDelimiter.guessed(string: "header,"), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: "id,name,age"), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: #""a","b","c""#), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: #""a;","b\t","c""#), .comma,
                       "Prioritizes separator between quotations over first occurrence")
    }

    func testGuessDelimiter_Semicolon() throws {
        XCTAssertEqual(CSVDelimiter.guessed(string: "header;"), .semicolon)
        XCTAssertEqual(CSVDelimiter.guessed(string: "id;name;age"), .semicolon)
        XCTAssertEqual(CSVDelimiter.guessed(string: #""a";"b";"c""#), .semicolon)
        XCTAssertEqual(CSVDelimiter.guessed(string: #""a,";"b\t";"c""#), .semicolon,
                       "Prioritizes separator between quotations over first occurrence")

        XCTAssertEqual(CSVDelimiter.guessed(string: """
"Test";"Test_1"
"Test";"Test_2"
"""), .semicolon)
    }

    func testGuessDelimiter_Tab() throws {
        XCTAssertEqual(CSVDelimiter.guessed(string: "header\t"), .tab)
        XCTAssertEqual(CSVDelimiter.guessed(string: "id\tname\tage"), .tab)
        // We cannot use #"..."# string delimiters here because \t doesn't work inside these.
        XCTAssertEqual(CSVDelimiter.guessed(string: "\"a\"\t\"b\"\t\"c\""), .tab)
        XCTAssertEqual(CSVDelimiter.guessed(string: "\"a,\"\t\"b;\"\t\"c\""), .tab,
                       "Prioritizes separator between quotations over first occurrence")
    }

    func testGuessDelimiter_IgnoresEmptyLeadingLines() throws {
        XCTAssertEqual(CSVDelimiter.guessed(string: "\na,b,c"), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: "\n\n\na,b,c"), .comma)
        XCTAssertEqual(CSVDelimiter.guessed(string: "\n  \n \na,b,c"), .comma)

        XCTAssertEqual(CSVDelimiter.guessed(string: "\na;b;c"), .semicolon)
        XCTAssertEqual(CSVDelimiter.guessed(string: "\n  \n \na;b;c"), .semicolon)

        XCTAssertEqual(CSVDelimiter.guessed(string: "\na\tb\tc"), .tab)
        XCTAssertEqual(CSVDelimiter.guessed(string: "\n  \n \na\tb\tc"), .tab)
    }

    
    func testInitWithGuessedDelimiter() throws {
        let semicolonCSV = try NamedCSV(string: "id;name;age\n1;Alice;18\n2;Bob;19\n3;Charlie")
        let expectedSemicolonCSV = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""]
        ]
        for (index, row) in semicolonCSV.rows.enumerated() {
            XCTAssertEqual(expectedSemicolonCSV[index], row)
        }

        let tabCSV = try NamedCSV(string: "id\tname\tage\n1\tAlice\t18\n2\tBob\t19\n3\tCharlie")
        let expectedTabCSV = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""]
        ]
        for (index, row) in tabCSV.rows.enumerated() {
            XCTAssertEqual(expectedTabCSV[index], row)
        }
    }
}
