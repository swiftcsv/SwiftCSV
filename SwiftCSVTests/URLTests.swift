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
    var csv: CSV<Named>!

    func testEmptyFields() throws {
        let csvURL = ResourceHelper.url(forResource: "empty_fields", withExtension: "csv")!
        csv = try CSV<Named>(url: csvURL)
        let expected = [
            ["id": "1", "name": "John", "age": "23"],
            ["id": "2", "name": "James", "age": "32"],
            ["id": "3", "name": "", "age": ""],
            ["id": "6", "name": "", "age": ""],
            ["id": "", "name": "", "age": ""],
            ["id": "", "name": "Tom", "age": ""]
        ]
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }

    func testQuotes() throws {
        let csvURL = ResourceHelper.url(forResource: "quotes", withExtension: "csv")!
        csv = try CSV<Named>(url: csvURL)
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
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }

    func testUTF8() throws {
        let csvURL = ResourceHelper.url(forResource: "utf8_with_bom", withExtension: "csv")!
        csv = try CSV(url: csvURL)

        XCTAssertFalse(csv.header.first!.hasPrefix("\u{FEFF}"))

        let expected = [
            [
                "Part Number": "12345",
                "Description": "Heizölrückstoßabdämpfung",
                "Unit Price": "€ 100,00",
                "Qty": "2"
            ]
        ]
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }

    func testUTF8Delimited() throws {
        let csvURL = ResourceHelper.url(forResource: "utf8_with_bom", withExtension: "csv")!
        csv = try CSV(url: csvURL, delimiter: .comma)

        XCTAssertFalse(csv.header.first!.hasPrefix("\u{FEFF}"))

        let expected = [
            [
                "Part Number": "12345",
                "Description": "Heizölrückstoßabdämpfung",
                "Unit Price": "€ 100,00",
                "Qty": "2"
            ]
        ]
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }
    
    func testBOMInHeadersWhenInitialisingFromString() throws {
        var csv: CSV<Named>?
        let csvString: String = """
Part Number,Description,Unit Price,Qty
12345,Heizölrückstoßabdämpfung,"€ 100,00",2"
"""
        let csvStringWithBOM = "\u{FEFF}" + csvString

        //	Make a CSV object
        do {
            //	Create from string
            csv = try CSV<Named>(string: csvStringWithBOM)
        } catch {
            XCTFail("Could not convert string literal to CSV instance")
        }
        
        //	Check that headers match
        let correctMatchingHeader = ["Part Number", "Description", "Unit Price", "Qty"]
        XCTAssertEqual(csv!.header, correctMatchingHeader)
    }
    
}
