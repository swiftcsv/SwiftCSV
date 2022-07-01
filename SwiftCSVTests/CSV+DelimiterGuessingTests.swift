//
//  CSV+DelimiterGuessingTests.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 21.12.21.
//  Copyright © 2021 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class CSV_DelimiterGuessingTests: XCTestCase {
    func testGuessDelimiter_InvalidInput_FallbackToComma() throws {
        XCTAssertEqual(Delimiter.guessed(string: ""), .comma)
        XCTAssertEqual(Delimiter.guessed(string: "    "), .comma)
        XCTAssertEqual(Delimiter.guessed(string: "fallback"), .comma)
        XCTAssertEqual(Delimiter.guessed(string: #""opened;quote;never;closed"#), .comma)
        XCTAssertEqual(Delimiter.guessed(string: "just a single line of text"), .comma)
        XCTAssertEqual(Delimiter.guessed(string: "\n"), .comma)
    }

    func testGuessDelimiter_Comma() throws {
        XCTAssertEqual(Delimiter.guessed(string: "header,"), .comma)
        XCTAssertEqual(Delimiter.guessed(string: "id,name,age"), .comma)
        XCTAssertEqual(Delimiter.guessed(string: #""a","b","c""#), .comma)
        XCTAssertEqual(Delimiter.guessed(string: #""a;","b\t","c""#), .comma,
                       "Prioritizes separator between quotations over first occurrence")
    }

    func testGuessDelimiter_Semicolon() throws {
        XCTAssertEqual(Delimiter.guessed(string: "header;"), .semicolon)
        XCTAssertEqual(Delimiter.guessed(string: "id;name;age"), .semicolon)
        XCTAssertEqual(Delimiter.guessed(string: #""a";"b";"c""#), .semicolon)
        XCTAssertEqual(Delimiter.guessed(string: #""a,";"b\t";"c""#), .semicolon,
                       "Prioritizes separator between quotations over first occurrence")
    }

    func testGuessDelimiter_Tab() throws {
        XCTAssertEqual(Delimiter.guessed(string: "header\t"), .tab)
        XCTAssertEqual(Delimiter.guessed(string: "id\tname\tage"), .tab)
        // We cannot use #"..."# string delimiters here because \t doesn't work inside these.
        XCTAssertEqual(Delimiter.guessed(string: "\"a\"\t\"b\"\t\"c\""), .tab)
        XCTAssertEqual(Delimiter.guessed(string: "\"a,\"\t\"b;\"\t\"c\""), .tab,
                       "Prioritizes separator between quotations over first occurrence")
    }

    func testGuessDelimiter_IgnoresEmptyLeadingLines() throws {
        XCTAssertEqual(Delimiter.guessed(string: "\na,b,c"), .comma)
        XCTAssertEqual(Delimiter.guessed(string: "\n\n\na,b,c"), .comma)
        XCTAssertEqual(Delimiter.guessed(string: "\n  \n \na,b,c"), .comma)

        XCTAssertEqual(Delimiter.guessed(string: "\na;b;c"), .semicolon)
        XCTAssertEqual(Delimiter.guessed(string: "\n  \n \na;b;c"), .semicolon)

        XCTAssertEqual(Delimiter.guessed(string: "\na\tb\tc"), .tab)
        XCTAssertEqual(Delimiter.guessed(string: "\n  \n \na\tb\tc"), .tab)
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
