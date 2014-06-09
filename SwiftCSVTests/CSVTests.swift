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
    var csv: CSV?
    
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
        XCTAssertEqualObjects(self.csv?.headers, expect, "")
    }
}
