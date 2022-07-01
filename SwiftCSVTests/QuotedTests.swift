//
//  QuotedTests.swift
//  SwiftCSV
//
//  Created by Will Richardson on 7/04/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import XCTest
import SwiftCSV

class QuotedTests: XCTestCase {
    var csv: CSV<Named>!

    override func setUpWithError() throws {
        csv = try CSV<Named>(string: "id,\"name, person\",age\n\"5\",\"Smith, John\",67\n8,Joe Bloggs,\"8\"")
    }
    
    func testQuotedHeader() {
        XCTAssertEqual(csv.header, ["id", "name, person", "age"])
    }
    
    func testQuotedContent() {
        let cols = csv.rows
        XCTAssertEqual(cols[0], [
            "id": "5",
            "name, person": "Smith, John",
            "age": "67"
        ])
        XCTAssertEqual(cols[1], [
            "id": "8",
            "name, person": "Joe Bloggs",
            "age": "8"
        ])
    }
}
