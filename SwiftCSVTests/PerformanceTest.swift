//
//  PerformanceTest.swift
//  SwiftCSV
//
//  Created by 杉本裕樹 on 2016/04/23.
//  Copyright © 2016年 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class PerformanceTest: XCTestCase {
    var csv: CSV<Named>!

    override func setUpWithError() throws {
        guard let csvURL = Bundle.module.url(forResource: "TestData/large", withExtension: "csv") else {
            XCTAssertNotNil(nil, "Could not get URL for Large.csv from Test Bundle")
            return
        }
        csv = try CSV<Named>(url: csvURL)
    }

    func testParsePerformance() {
        measure {
            _ = self.csv.rows
        }
    }
}
