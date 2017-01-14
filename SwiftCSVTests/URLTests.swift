//
//  URLTests.swift
//  SwiftCSV
//
//  Created by Will Richardson on 8/04/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import XCTest
import SwiftCSV

class URLTests: XCTestCase {
    var csv: CSV!
    
    func testEmptyFields() {
        let csvURL = Bundle(for: CSVTests.self).url(forResource: "empty_fields", withExtension: "csv")!
        csv = try! CSV(url: csvURL)
        let expected = [
            ["id": "1", "name": "John", "age": "23"],
            ["id": "2", "name": "James", "age": "32"],
            ["id": "3", "name": "", "age": ""],
            ["id": "6", "name": "", "age": ""],
            ["id": "", "name": "", "age": ""],
            ["id": "", "name": "Tom", "age": ""]
        ]
        for (index, row) in csv.namedRows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }
    
    func testQuotes() {
        let csvURL = Bundle(for: CSVTests.self).url(forResource: "quotes", withExtension: "csv")!
        csv = try! CSV(url: csvURL)
        let expected = [
            ["id": "4", "name, first": "Alex", "name, last": "Smith"],
            ["id": "5", "name, first": "Joe", "name, last": "Bloggs"],
            [
                "id": "9",
                "name, first": "Person, with a \"quote\" in their name",
                "name, last": "uugh"
            ],
            [
                "id": "10",
                "name, first": "Person, with escaped comma",
                "name, last": "Jones"
            ],
            [
                "id": "10",
                "name, first": "Person\\ with a backslash",
                "name, last": "Jones"
            ],
            [
                "id": "12",
                "name, first": "Newlines\nare the best",
                "name, last": "Woo hoo"
            ],
            [:]
        ]
        for (index, row) in csv.namedRows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }
    
}
