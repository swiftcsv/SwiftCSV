//
//  NewlineTests.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 05/12/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class NewlineTests: XCTestCase {
    func testInit_withCR() throws {
        let csv = try CSV<Named>(string: "id,name,age\r1,Alice,18\r2,Bob,19\r3,Charlie,20")
        XCTAssertEqual(csv.header, ["id", "name", "age"])
        let expectedRows = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expectedRows[index], row)
        }
    }

    func testInit_withLF() throws {
        let csv = try CSV<Named>(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20")
        XCTAssertEqual(csv.header, ["id", "name", "age"])
        let expectedRows = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expectedRows[index], row)
        }
    }

    func testInit_withCRLF() throws {
        let csv = try CSV<Named>(string: "id,name,age\r\n1,Alice,18\r\n2,Bob,19\r\n3,Charlie,20")
        XCTAssertEqual(csv.header, ["id", "name", "age"])
        let expectedRows = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ]
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expectedRows[index], row)
        }
    }

    func testInit_whenThereIsExtraCarriageReturnAtTheEnd() throws {
        let csv = try CSV<Named>(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie\r\n")
        let expected = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""]
        ]
        for (index, row) in csv.rows.enumerated() {
            XCTAssertEqual(expected[index], row)
        }
    }
}
