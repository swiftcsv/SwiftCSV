//
//  NamedViewTests.swift
//  CSVTests
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class NamedViewTests: XCTestCase {
    func testSuppliedHeadersRetainFirstRow() throws {
        let csv = try NamedCSV(string: "1,Alice\n2,Bob", header: ["id", "name"])
        XCTAssertEqual(csv.rows, [["id": "1", "name": "Alice"], ["id": "2", "name": "Bob"]])
        XCTAssertEqual(csv.columns, ["id": ["1", "2"], "name": ["Alice", "Bob"]])
        XCTAssertEqual(csv.text, "1,Alice\n2,Bob")
        var enumerated: [[String: String]] = []
        try csv.enumerateAsDict { enumerated.append($0) }
        XCTAssertEqual(enumerated, csv.rows)
        let roundTrip = try NamedCSV(string: csv.serialized)
        XCTAssertEqual(roundTrip.rows, csv.rows)
    }

    func testSuppliedHeadersWithBOMQuotesAndCustomDelimiter() throws {
        let csv = try NamedCSV(string: "\u{FEFF}1;\"Alice; A\"\n2;Bob", header: ["id", "name"],
                               delimiter: .semicolon, loadColumns: false, rowLimit: 1)
        XCTAssertEqual(csv.rows, [["id": "1", "name": "Alice; A"]])
        XCTAssertNil(csv.columns)
        XCTAssertFalse(csv.text.hasPrefix("\u{FEFF}"))
    }

    func testSuppliedHeadersValidateEachRow() throws {
        XCTAssertThrowsError(try NamedCSV(string: "1\n2,Bob", header: ["id"]))
        let csv = try NamedCSV(string: "1,Alice\n2", header: ["id", "name", "age"])
        XCTAssertEqual(csv.rows, [
            ["id": "1", "name": "Alice", "age": ""],
            ["id": "2", "name": "", "age": ""]
        ])
    }

    func testSuppliedHeadersWithEmptyInputAndZeroLimit() throws {
        XCTAssertEqual(try NamedCSV(string: "", header: ["id"]).rows, [])
        XCTAssertEqual(try NamedCSV(string: "1\n2", header: ["id"], rowLimit: 0).rows, [])
    }

    let string = "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20"
    var csv: CSV<Named>!

    override func setUpWithError() throws {
        csv = try CSV<Named>(string: string)
    }

    override func tearDownWithError() throws {
        csv = nil
    }

    func testHeader() {
        XCTAssertEqual(csv.header, ["id", "name", "age"])
    }
    
    func testRows() {
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        XCTAssertEqual(csv.rows, expected)
    }

    func testRows_WithLimit() throws {
        csv = try CSV<Named>(string: string, delimiter: ",", rowLimit: 2)
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
        ]
        XCTAssertEqual(csv.rows, expected)
    }

    func testColumns() {
        let expected = [
            "id": ["1", "2", "3"],
            "name": ["Alice", "Bob", "Charlie"],
            "age": ["18", "19", "20"]
        ]
        XCTAssertEqual(csv.columns, expected)
    }

    func testColumns_WithLimit() throws {
        csv = try CSV<Named>(string: string, delimiter: ",", rowLimit: 2)
        let expected = [
            "id": ["1", "2"],
            "name": ["Alice", "Bob"],
            "age": ["18", "19"]
        ]
        XCTAssertEqual(csv.columns, expected)
    }

    func testFillsIncompleteRows() throws {
        csv = try CSV<Named>(string: "id,name,age\n1,Alice,18\n2,,19\n3,Charlie")

        let expectedRows = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""]
        ]
        XCTAssertEqual(csv.rows, expectedRows)

        let expectedColumns = [
            "id": ["1", "2", "3"],
            "name": ["Alice", "", "Charlie"],
            "age": ["18", "19", ""]
        ]
        XCTAssertEqual(csv.columns, expectedColumns)
    }

    func testSerialization() {
        XCTAssertEqual(csv.serialized, "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20")
    }
  
    func testSerializationWithDoubleQuotes() throws {
        csv = try CSV<Named>(string: "id,\"the, name\",age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
        XCTAssertEqual(csv.serialized, "id,\"the, name\",age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
    }
  
    func testEnumerate() throws {
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        var index = 0
        try csv.enumerateAsDict { row in
            XCTAssertEqual(row, expected[index])
            index += 1
        }
    }

    func testIgnoreColumns() throws {
        csv = try CSV<Named>(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20", delimiter: ",", loadColumns: false)
        XCTAssertNil(csv.columns)
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }
  
    func testInit_ParseCommaSeparatedFileWithQuotesAndWhitespaces() throws {
        let tab = "\t"
        let paragraphSeparator = "\u{2029}"
        let ideographicSpace = "\u{3000}"
      
        let failingCsv = """
        "a" \(tab)  ,  \(paragraphSeparator)  "b"
        "A" \(ideographicSpace)  ,  \(tab)   "B"
        """
        let csv = try CSV<Named>(string: failingCsv, delimiter: .comma)
        
        XCTAssertEqual(csv.rows, [["b": "B", "a": "A"]])

        XCTAssertThrowsError(try CSV<Named>(string: failingCsv),
                             "Delimiter guessing should fail here.")
    }
}
