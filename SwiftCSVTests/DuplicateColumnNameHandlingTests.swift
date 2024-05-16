//
//  DuplicateColumnNameHandlingTests.swift
//
//
//  Created by 胡逸飞 on 2024/4/27.
//

import Foundation
import XCTest
@testable import SwiftCSV

class DuplicateColumnNameHandlingTests: XCTestCase {
    
    func testErrorOnDuplicateColumnNames() throws {
        let csvString = """
        id,name,age,name
        1,John,23,John Doe
        2,Jane,25,Jane Doe
        """
        
        XCTAssertThrowsError(try CSV<Named>(string: csvString)) { error in
            XCTAssertEqual(error as? CSVParseError, CSVParseError.generic(message: "Duplicate column names found: name"))
        }
    }
    
    func testNoDuplicateColumnNames() throws {
        let csvString = """
        id,name,age
        1,John,23
        2,Jane,25
        """
        
        let csvError = try CSV<Named>(string: csvString)
        let csvRandom = try CSV<Named>(string: csvString)
        
        XCTAssertEqual(csvError.header, ["id", "name", "age"])
        XCTAssertEqual(csvRandom.header, ["id", "name", "age"])
        
        XCTAssertEqual(csvError.rows.count, 2)
        XCTAssertEqual(csvRandom.rows.count, 2)
        
        XCTAssertEqual(csvError.rows[0]["id"], "1")
        XCTAssertEqual(csvError.rows[0]["name"], "John")
        XCTAssertEqual(csvError.rows[0]["age"], "23")
        
        XCTAssertEqual(csvRandom.rows[0]["id"], "1")
        XCTAssertEqual(csvRandom.rows[0]["name"], "John")
        XCTAssertEqual(csvRandom.rows[0]["age"], "23")
        
        XCTAssertEqual(csvError.rows[1]["id"], "2")
        XCTAssertEqual(csvError.rows[1]["name"], "Jane")
        XCTAssertEqual(csvError.rows[1]["age"], "25")
        
        XCTAssertEqual(csvRandom.rows[1]["id"], "2")
        XCTAssertEqual(csvRandom.rows[1]["name"], "Jane")
        XCTAssertEqual(csvRandom.rows[1]["age"], "25")
    }
    
}
