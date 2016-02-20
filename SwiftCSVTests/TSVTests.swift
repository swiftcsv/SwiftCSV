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
        let url = NSBundle(forClass: TSVTests.self).URLForResource("users", withExtension: "tsv")!
        let tab = NSCharacterSet(charactersInString: "\t")
        tsv = try! CSV(url: url, delimiter: tab)
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