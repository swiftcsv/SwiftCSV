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

    override func setUpWithError() throws {
        csv = try CSV<Enumerated>(string: string, delimiter: ",", loadColumns: true)
    }

    override func tearDownWithError() throws {
        csv = nil
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
        csv = try CSV<Enumerated>(string: string, delimiter: ",", rowLimit: 2)
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

    func testColumns_WithLimit() throws {
        csv = try CSV<Enumerated>(string: string, delimiter: ",", rowLimit: 2)
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

    func testSerializationWithDoubleQuotes() throws {
        csv = try CSV<Enumerated>(string: "id,\"the, name\",age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
        XCTAssertEqual(csv.serialized, "id,\"the, name\",age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
    }

    func testSerializationWithDifferentDelimiters() throws {
        csv = try CSV<Enumerated>(string: "id\tname\tage\n1\tAlice\t18\n2\tBob\t19\n3\tCharlie\t20")
        XCTAssertEqual(csv.serialized, "id\tname\tage\n1\tAlice\t18\n2\tBob\t19\n3\tCharlie\t20")

        csv = try CSV<Enumerated>(string: "id\t\"the\t name\"\tage\n1\t\"Alice\t In\t Wonderland\"\t18\n2\tBob\t19\n3\tCharlie\t20")
        XCTAssertEqual(csv.serialized, "id\t\"the\t name\"\tage\n1\t\"Alice\t In\t Wonderland\"\t18\n2\tBob\t19\n3\tCharlie\t20")

        csv = try CSV<Enumerated>(string: "id\tthe, name,age\n1\tAlice, In, Wonderland\t18\n2\tBob\t19\n3\tCharlie\t20", delimiter: .tab)
        XCTAssertEqual(csv.serialized, "id\tthe, name,age\n1\tAlice, In, Wonderland\t18\n2\tBob\t19\n3\tCharlie\t20")
    }
}
