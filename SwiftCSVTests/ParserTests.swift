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


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: nil, startAt: 0),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: -1, startAt: 0),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: nil, startAt: 1),
                       [["1","foo"], ["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: nil, startAt: 2),
                       [["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: nil, startAt: 3),
                       [["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: nil, startAt: 4),
                       [])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 1, startAt: 5),
                       [])


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 0, startAt: 0),
                       [["id","name"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 1, startAt: 0),
                       [["id","name"], ["1","foo"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 2, startAt: 0),
                       [["id","name"], ["1","foo"], ["2","bar"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 3, startAt: 0),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 4, startAt: 0),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 999, startAt: 0),
                       [["id","name"], ["1","foo"], ["2","bar"], ["3","baz"]])


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 1, startAt: 1),
                       [["1","foo"]])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 2, startAt: 1),
                       [["1","foo"], ["2","bar"]])


        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 1, startAt: 2),
                       [])
        XCTAssertEqual(try Parser.array(text: string, delimiter: ",", limitTo: 2, startAt: 2),
                       [["2","bar"]])
    }
}
