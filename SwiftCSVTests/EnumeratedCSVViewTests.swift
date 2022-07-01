//
//  EnumeratedViewTests.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 2016-10-25.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class EnumeratedViewTests: XCTestCase {
    let string = "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20"
    var csv: CSV<Enumerated>!

    override func setUp() {
        super.setUp()

        csv = try! CSV<Enumerated>(string: string, delimiter: ",", loadColumns: true)
    }

    override func tearDown() {
        csv = nil
        super.tearDown()
    }

    func testRows() {
        let expected = [
            ["1", "Alice", "18"],
            ["2", "Bob", "19"],
            ["3", "Charlie", "20"]
        ]
        XCTAssertEqual(csv.rows, expected)
    }

    func testRows_WithLimit() throws {
        csv = try! CSV<Enumerated>(string: string, delimiter: ",", rowLimit: 2)
        let expected = [
            ["1", "Alice", "18"],
            ["2", "Bob", "19"]
        ]
        XCTAssertEqual(csv.rows, expected)
    }

    func testColumns() {
        let expected = [
            Enumerated.Column(header: "id", rows: ["1", "2", "3"]),
            Enumerated.Column(header: "name", rows: ["Alice", "Bob", "Charlie"]),
            Enumerated.Column(header: "age", rows: ["18", "19", "20"])
        ]
        XCTAssertEqual(csv.columns, expected)
    }

    func testColumns_WithLimit() {
        csv = try! CSV<Enumerated>(string: string, delimiter: ",", rowLimit: 2)
        let expected = [
            Enumerated.Column(header: "id", rows: ["1", "2"]),
            Enumerated.Column(header: "name", rows: ["Alice", "Bob"]),
            Enumerated.Column(header: "age", rows: ["18", "19"])
        ]
        XCTAssertEqual(csv.columns, expected)
    }

    func testFillsIncompleteRows() throws {
        csv = try CSV<Enumerated>(string: "id,name,age\n1,Alice,18\n2\n3,Charlie", delimiter: ",", loadColumns: true)

        let expectedRows = [
            ["1", "Alice", "18"],
            ["2", "", ""],
            ["3", "Charlie", ""]
        ]
        XCTAssertEqual(csv.rows, expectedRows)

        let expectedColumns = [
            Enumerated.Column(header: "id", rows: ["1", "2", "3"]),
            Enumerated.Column(header: "name", rows: ["Alice", "", "Charlie"]),
            Enumerated.Column(header: "age", rows: ["18", "", ""])
        ]
        XCTAssertEqual(csv.columns, expectedColumns)
    }

    func testSerialization() {
        XCTAssertEqual(csv.serialized, "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20")
    }

    func testSerializationWithDoubleQuotes() {
        csv = try! CSV<Enumerated>(string: "id,\"the, name\",age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
        XCTAssertEqual(csv.serialized, "id,\"the, name\",age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
    }
}
