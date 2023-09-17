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
        let testFilePath = "TestData/large"
        let testFileExtension = "csv"
        guard let csvURL = ResourceHelper.url(forResource: testFilePath, withExtension: testFileExtension) else {
            XCTAssertNotNil(nil, "Could not get URL for \(testFilePath).\(testFileExtension) from Test Bundle")
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
