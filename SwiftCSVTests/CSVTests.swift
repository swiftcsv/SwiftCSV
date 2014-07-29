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
        super.setUp()
        
        let bundle = NSBundle(forClass: CSVTests.self)
        let url = bundle.URLForResource("users", withExtension: "csv")
        self.csv = CSV(contentsOfURL: url)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHeaders() {
        let expect = ["id", "name", "age"]
//        XCTAssertEqual(self.csv.headers, expect, "")
    }
    
    func testRows() {
        let expect = [
            ["id": 1, "name": "Alice", "age": 18],
            ["id": 2, "name": "Bob", "age": 19],
            ["id": 3, "name": "Charlie", "age": 20],
        ]
//        XCTAssertEqual(self.csv.rows, expect, "")
    }
    
    func testColumns() {
        let expect = [
            "id": [1, 2, 3],
            "name": ["Alice", "Bob", "Charlie"],
            "age": [18, 19, 20]
        ]
//        XCTAssertEqual(self.csv.columns, expect, "")
    }
}
