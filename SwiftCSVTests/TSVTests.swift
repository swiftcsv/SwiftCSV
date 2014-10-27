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
    var tsv: CSV!
    var error: NSErrorPointer = nil
    
    override func setUp() {
        let url = NSBundle(forClass: TSVTests.self).URLForResource("users", withExtension: "tsv")
        let tab = NSCharacterSet(charactersInString: "\t")
        tsv = CSV(contentsOfURL: url!, delimiter: tab, error: error)
    }
    
    func testHeaders() {
        XCTAssertEqual(tsv.headers, ["id", "name", "age"], "")
    }
    
    func testRows() {
        let expects = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"],
        ]
        XCTAssertEqual(tsv.rows, expects, "")
    }
    
    func testColumns() {
        XCTAssertEqual(["id": ["1", "2", "3"], "name": ["Alice", "Bob", "Charlie"], "age": ["18", "19", "20"]], tsv.columns, "")
    }
}
