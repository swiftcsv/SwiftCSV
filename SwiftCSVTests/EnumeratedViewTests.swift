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

    var csv: CSV!

    override func setUp() {
        super.setUp()

        csv = try! CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20", delimiter: ",", loadColumns: true)
    }

    func testExposesRows() {
        let expected: [[String]] = [
            ["1", "Alice", "18"],
            ["2", "Bob", "19"],
            ["3", "Charlie", "20"]
        ]
        let actual = csv.enumeratedRows

        // Abort if counts don't match to not raise index-out-of-bounds exception
        guard actual.count == expected.count else {
            XCTFail("expected actual.count (\(actual.count)) to equal expected.count (\(expected.count))")
            return
        }

        for i in actual.indices {
            XCTAssertEqual(actual[i], expected[i])
        }
    }

    func testExposesColumns() {
        let actual = csv.enumeratedColumns

        // Abort if counts don't match to not raise index-out-of-bounds exception
        guard actual.count == 3 else {
            XCTFail("expected actual.count to equal 3")
            return
        }

        XCTAssertEqual(actual[0].header, "id")
        XCTAssertEqual(actual[0].rows, ["1", "2", "3"])

        XCTAssertEqual(actual[1].header, "name")
        XCTAssertEqual(actual[1].rows, ["Alice", "Bob", "Charlie"])

        XCTAssertEqual(actual[2].header, "age")
        XCTAssertEqual(actual[2].rows, ["18", "19", "20"])
    }
}
