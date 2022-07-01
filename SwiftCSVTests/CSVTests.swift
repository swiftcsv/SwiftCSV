//
//  CSVTests.swift
//  CSVTests
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class CSVTests: XCTestCase {
    var csv: CSV!
    
    override func setUp() {
        csv = try! CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20", delimiter: .comma)
    }
    
    func testInit_makesHeader() {
        XCTAssertEqual(csv.header, ["id", "name", "age"])
    }
    
    func testInit_makesRows() {
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        for (index, row) in csv.namedRows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }
    
    func testInit_whenThereAreIncompleteRows_makesRows() {
        csv = try! CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie", delimiter: .comma)
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""]
        ]
        for (index, row) in csv.namedRows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }

    func testInit_whenThereAreextraCarriageReturns() throws {
        csv = try CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie\r\n")
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""]
        ]
        for (index, row) in csv.namedRows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }
    
    func testInit_whenThereAreCRLFs_makesRows() {
        csv = try! CSV(string: "id,name,age\r\n1,Alice,18\r\n2,Bob,19\r\n3,Charlie,20\r\n", delimiter: .comma)
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        for (index, row) in csv.namedRows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }
    
    func testInit_makesColumns() {
        let expected = [
            "id": ["1", "2", "3"],
            "name": ["Alice", "Bob", "Charlie"],
            "age": ["18", "19", "20"]
        ]
        XCTAssertEqual(Set(csv.namedColumns.keys), Set(expected.keys))
        for (key, value) in csv.namedColumns {
            XCTAssertEqual(expected[key] ?? [], value)
        }
    }
    
    func testDescription() {
        XCTAssertEqual(csv.description, "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20")
    }
  
    func testDescriptionWithDoubleQuotes() {
        csv = try! CSV(string: "id,name,age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20", delimiter: .comma)
        XCTAssertEqual(csv.description, "id,name,age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
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
        csv = try! CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20", delimiter: .comma, loadColumns: false)
        XCTAssertEqual(csv.namedColumns.isEmpty, true)
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        for (index, row) in csv.namedRows.enumerated() {
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
        let csv = try! CSV(string: failingCsv, delimiter: .comma)
        
        XCTAssertEqual(csv.namedRows, [["b": "B", "a": "A"]])
    }
}
