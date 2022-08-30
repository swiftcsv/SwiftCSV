//
//  QuotedTests.swift
//  SwiftCSV
//
//  Created by Will Richardson on 7/04/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import XCTest
import SwiftCSV

class QuotedTests: XCTestCase {
    var csv: CSV<Named>!

    override func setUpWithError() throws {
        csv = try CSV<Named>(string: "id,\"name, person\",age\n\"5\",\"Smith, John\",67\n8,Joe Bloggs,\"8\"")
    }
    
    func testQuotedHeader() {
        XCTAssertEqual(csv.header, ["id", "name, person", "age"])
    }
    
    func testQuotedContent() {
        let cols = csv.rows
        XCTAssertEqual(cols[0], [
            "id": "5",
            "name, person": "Smith, John",
            "age": "67"
        ])
        XCTAssertEqual(cols[1], [
            "id": "8",
            "name, person": "Joe Bloggs",
            "age": "8"
        ])
    }

    func testEmbeddedQuotes() throws {
        let csvURL = ResourceHelper.url(forResource: "wonderland", withExtension: "csv")!
        csv = try CSV(url: csvURL)

        /*
         The test file:

         Character,Quote
         White Rabbit,"""Where shall I begin, please your Majesty?"" he asked."
         King,"""Begin at the beginning,"" the King said gravely, ""and go on till you come to the end: then stop."""
         March Hare,"""Do you mean that you think you can find out the answer to it?"" said the March Hare."

         Notice there are no commas (delimiters) in the 3rd line.
         For more information, see https://www.rfc-editor.org/rfc/rfc4180.html
         */

        let expected = [
            [ "Character" : "White Rabbit" , "Quote" : #""Where shall I begin, please your Majesty?" he asked."# ],
            [ "Character" : "King"         , "Quote" : #""Begin at the beginning," the King said gravely, "and go on till you come to the end: then stop.""# ],
            [ "Character" : "March Hare"   , "Quote" : #""Do you mean that you think you can find out the answer to it?" said the March Hare."# ]
        ]
        
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }

        let serialized = csv.serialized
        let read = try String(contentsOf: csvURL, encoding: .utf8)
        XCTAssertEqual(serialized, read)
    }
}
