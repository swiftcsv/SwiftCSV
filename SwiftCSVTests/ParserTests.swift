//
//  ParserTests.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 22.11.21.
//  Copyright © 2021 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class ParserTests: XCTestCase {
    func testParseArray_RowLimitAndOffset() throws {
        let string = "id,name\n1,foo\n2,bar\n3,baz"


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 1, rowLimit: nil),
                       [["1","foo"], ["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 2, rowLimit: nil),
                       [["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 3, rowLimit: nil),
                       [["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 4, rowLimit: nil),
                       [])


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 0, rowLimit: nil),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 0, rowLimit: -1),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 0, rowLimit: 0),
                       [])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 0, rowLimit: 1),
                       [["id","name"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 0, rowLimit: 2),
                       [["id","name"], ["1","foo"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 0, rowLimit: 3),
                       [["id","name"], ["1","foo"], ["2","bar"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 0, rowLimit: 4),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 0, rowLimit: 5),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 0, rowLimit: 999),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 1, rowLimit: 1),
                       [["1","foo"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 1, rowLimit: 2),
                       [["1","foo"], ["2","bar"]])


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 2, rowLimit: 1),
                       [["2","bar"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 2, rowLimit: 2),
                       [["2","bar"], ["3","baz"]])


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", startAt: 5, rowLimit: 1),
                       [])
    }
}
