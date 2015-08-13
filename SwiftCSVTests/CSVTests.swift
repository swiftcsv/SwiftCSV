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
    var csvWithCRLF: CSV!
    var csvFromString: CSV!
    var error: NSErrorPointer = nil
    
    override func setUp() {
        let csvURL = NSBundle(forClass: CSVTests.self).URLForResource("users", withExtension: "csv")
        do {
            csv = try CSV(contentsOfURL: csvURL!)
        } catch let error1 as NSError {
            error.memory = error1
            csv = nil
        }
        
        let csvWithCRLFURL = NSBundle(forClass: CSVTests.self).URLForResource("users_with_crlf", withExtension: "csv")
        do {
            csvWithCRLF = try CSV(contentsOfURL: csvWithCRLFURL!)
        } catch let error1 as NSError {
            error.memory = error1
            csvWithCRLF = nil
        }
        
        let csvString = "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,\n"
        do {
            csvFromString = try CSV(csvString: csvString)
        } catch let error1 as NSError {
            error.memory = error1
            csvFromString = nil
        }
    }
    
    func testHeaders() {
        XCTAssertEqual(csv.headers, ["id", "name", "age"], "")
        XCTAssertEqual(csvWithCRLF.headers, ["id", "name", "age"], "")
        XCTAssertEqual(csvFromString.headers, ["id", "name", "age"], "")
    }
    
    func testRows() {
        let expects = [
            ["id": "1", "name": "Alice", "age": "18"],
            ["id": "2", "name": "Bob", "age": "19"],
            ["id": "3", "name": "Charlie", "age": ""],
        ]
        XCTAssertEqual(csv.rows, expects, "")
        XCTAssertEqual(csvWithCRLF.rows, expects, "")
        XCTAssertEqual(csvFromString.rows, expects, "")
    }
    
    func testColumns() {
        XCTAssertEqual(["id": ["1", "2", "3"], "name": ["Alice", "Bob", "Charlie"], "age": ["18", "19", ""]], csv.columns, "")
        XCTAssertEqual(["id": ["1", "2", "3"], "name": ["Alice", "Bob", "Charlie"], "age": ["18", "19", ""]], csvWithCRLF.columns, "")
         XCTAssertEqual(["id": ["1", "2", "3"], "name": ["Alice", "Bob", "Charlie"], "age": ["18", "19", ""]], csvFromString.columns, "")
    }
}
