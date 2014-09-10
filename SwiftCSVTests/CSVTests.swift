//
//  CSVTests.swift
//  CSVTests
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import XCTest
import SwiftCSV

class CSVTests: XCTestCase {
    var csv: CSV!
    
    override func setUp() {
        let url = NSBundle(forClass: CSVTests.self).URLForResource("users", withExtension: "csv")
        csv = CSV(contentsOfURL: url!)
    }
    
    func testHeaders() {
        XCTAssertEqual(csv.headers, ["id", "name", "age"], "")
    }
    
    func testRows() {
        let expects = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"],
        ]
        XCTAssertEqual(csv.rows, expects, "")
    }
    
    func testColumns() {
//        let expects = [
//            "id": ["1", "2", "3"],
//            "name": ["Alice", "Bob", "Charlie"],
//            "age": ["18", "19", "20"]
//        ]
//        XCTAssertEqual(csv.columns, expects, "")
        XCTAssertEqual(["id": ["1", "2", "3"], "name": ["Alice", "Bob", "Charlie"], "age": ["18", "19", "20"]], csv.columns, "")
    }
}
