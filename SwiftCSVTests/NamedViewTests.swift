//
//  NamedViewTests.swift
//  CSVTests
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class CSVTests: XCTestCase {
    let string = "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20"
    var csv: CSV<Named>!
    
    override func setUp() {
        csv = try! CSV<Named>(string: string)
    }

    override func tearDown() {
        csv = nil
        super.tearDown()
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

    func testRows_WithLimit() {
        csv = try! CSV<Named>(string: string, rowLimit: 2)
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

    func testColumns_WithLimit() {
        csv = try! CSV<Named>(string: string, rowLimit: 2)
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
  
    func testSerializationWithDoubleQuotes() {
        csv = try! CSV<Named>(string: "id,\"the, name\",age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
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

    func testIgnoreColumns() {
        csv = try! CSV<Named>(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20", delimiter: ",", loadColumns: false)
        XCTAssertEqual(csv.columns.isEmpty, true)
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }
  
    func testInit_ParseFileWithQuotesAndWhitespaces() {
        let tab = "\t"
        let paragraphSeparator = "\u{2029}"
        let ideographicSpace = "\u{3000}"
      
        let failingCsv = """
        "a" \(tab)  ,  \(paragraphSeparator)  "b"
        "A" \(ideographicSpace)  ,  \(tab)   "B"
        """
        let csv = try! CSV<Named>(string: failingCsv)
        
        XCTAssertEqual(csv.rows, [["b": "B", "a": "A"]])
    }
}
