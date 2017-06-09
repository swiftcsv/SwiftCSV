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
    var csv: CSV!

    override func setUp() {
        // Load files this way so tests run in Xcode and with `swift test`
        let csvURL = NSURL(fileURLWithPath: #file).deletingLastPathComponent!.appendingPathComponent("large.csv")
        csv = try! CSV(url: csvURL)
    }

    func testParsePerformance() {
        measure {
            _ = self.csv.namedRows
        }
    }
}
