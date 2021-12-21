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
        XCTAssertEqual(CSV.guessedDelimiter(string: ""), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: "    "), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: "fallback"), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: #""opened;quote;never;closed"#), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: "just a single line of text"), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: "\n"), .comma)
    }

    func testGuessDelimiter_Comma() throws {
        XCTAssertEqual(CSV.guessedDelimiter(string: "header,"), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: "id,name,age"), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: #""a","b","c""#), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: #""a;","b\t","c""#), .comma,
                       "Prioritizes separator between quotations over first occurrence")
    }

    func testGuessDelimiter_Semicolon() throws {
        XCTAssertEqual(CSV.guessedDelimiter(string: "header;"), .semicolon)
        XCTAssertEqual(CSV.guessedDelimiter(string: "id;name;age"), .semicolon)
        XCTAssertEqual(CSV.guessedDelimiter(string: #""a";"b";"c""#), .semicolon)
        XCTAssertEqual(CSV.guessedDelimiter(string: #""a,";"b\t";"c""#), .semicolon,
                       "Prioritizes separator between quotations over first occurrence")
    }

    func testGuessDelimiter_Tab() throws {
        XCTAssertEqual(CSV.guessedDelimiter(string: "header\t"), .tab)
        XCTAssertEqual(CSV.guessedDelimiter(string: "id\tname\tage"), .tab)
        // We cannot use #"..."# string delimiters here because \t doesn't work inside these.
        XCTAssertEqual(CSV.guessedDelimiter(string: "\"a\"\t\"b\"\t\"c\""), .tab)
        XCTAssertEqual(CSV.guessedDelimiter(string: "\"a,\"\t\"b;\"\t\"c\""), .tab,
                       "Prioritizes separator between quotations over first occurrence")
    }

    func testGuessDelimiter_IgnoresEmptyLeadingLines() throws {
        XCTAssertEqual(CSV.guessedDelimiter(string: "\na,b,c"), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: "\n\n\na,b,c"), .comma)
        XCTAssertEqual(CSV.guessedDelimiter(string: "\n  \n \na,b,c"), .comma)

        XCTAssertEqual(CSV.guessedDelimiter(string: "\na;b;c"), .semicolon)
        XCTAssertEqual(CSV.guessedDelimiter(string: "\n  \n \na;b;c"), .semicolon)

        XCTAssertEqual(CSV.guessedDelimiter(string: "\na\tb\tc"), .tab)
        XCTAssertEqual(CSV.guessedDelimiter(string: "\n  \n \na\tb\tc"), .tab)
    }

    
    func testInitWithGuessedDelimiter() {
        let semicolonCSV = try! CSV(string: "id;name;age\n1;Alice;18\n2;Bob;19\n3;Charlie")
        let expectedSemicolonCSV = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""]
        ]
        for (index, row) in semicolonCSV.namedRows.enumerated() {
            XCTAssertEqual(expectedSemicolonCSV[index], row)
        }

        let tabCSV = try! CSV(string: "id\tname\tage\n1\tAlice\t18\n2\tBob\t19\n3\tCharlie")
        let expectedTabCSV = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""]
        ]
        for (index, row) in tabCSV.namedRows.enumerated() {
            XCTAssertEqual(expectedTabCSV[index], row)
        }
    }
}
