//
//  TSVTests.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/15.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import XCTest
import SwiftCSV

class TSVTests: XCTestCase {
    var tsv: CSV?

    override func setUp() {
        super.setUp()
        
        let bundle = NSBundle(forClass: TSVTests.self)
        let url = bundle.URLForRecource("users", withExtension: "tsv")
        self.tsv = CSV(contentsOfURL: url, separator: "\t")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHeaders() {
        let expect = ["id", "name", "age"]
        XCTAssertEqualObjects(self.tsv?.headers, expect, "")
    }
    
    func testRows() {
        let expect = [
            ["id": 1, "name": "Alice", "age": 18],
            ["id": 2, "name": "Bob", "age": 19],
            ["id": 3, "name": "Charlie", "age": 20],
        ]
        XCTAssertEqualObjects(self.tsv?.rows, expect, "")
    }
    
    func testColumns() {
        let expect = [
            "id": [1, 2, 3],
            "name": ["Alice", "Bob", "Charlie"],
            "age": [18, 19, 20]
        ]
        XCTAssertEqualObjects(self.tsv?.columns, expect, "")
    }

}
