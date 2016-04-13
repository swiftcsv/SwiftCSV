//
//  TSVTests.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/15.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import XCTest
import Foundation
@testable import SwiftCSV

class TSVTests: XCTestCase {
    var tsv: CSV!
    
    override func setUp() {
        tsv = CSV(string: "id\tname\tage\n1\tAlice\t18\n2\tBob\t19\n3\tCharlie\t20", delimiter: "\t")
    }
    
    func testInit_makesHeader() {
        XCTAssertEqual(tsv.header, ["id", "name", "age"])
    }
    
    func testInit_makesRows() {
        XCTAssertEqual(tsv.rows, [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": "20"]
        ])
    }
    
    func testInit_makesColumns() {
        XCTAssertEqual(tsv.columns, [
            "id": ["1", "2", "3"],
            "name": ["Alice", "Bob", "Charlie"],
            "age": ["18", "19", "20"]
        ])
    }
}
