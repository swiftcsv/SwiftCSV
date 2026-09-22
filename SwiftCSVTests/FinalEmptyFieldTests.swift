import XCTest
@testable import SwiftCSV

class FinalEmptyFieldTests: XCTestCase {
    func testTrailingEmptyFieldIsPreservedWithoutNewline() throws {
        for suffix in [",", ",\"\"", ",,"] {
            let withoutNewline = try Parser.array(text: "value" + suffix, delimiter: .comma)
            let withNewline = try Parser.array(text: "value" + suffix + "\n", delimiter: .comma)
            XCTAssertEqual(withoutNewline, withNewline)
        }
    }

    func testQuotedEmptySingleFieldIsPreserved() throws {
        XCTAssertEqual(try Parser.array(text: "\"\"", delimiter: .comma), [[""]])
        let csv = try EnumeratedCSV(string: "header\n\"\"", delimiter: .comma)
        XCTAssertEqual(csv.rows, [[""]])
    }

    func testHeaderAndRowKeepTrailingEmptyColumns() throws {
        let csv = try EnumeratedCSV(string: "name,\nAlice,", delimiter: .comma)
        XCTAssertEqual(csv.header, ["name", ""])
        XCTAssertEqual(csv.rows, [["Alice", ""]])
        XCTAssertEqual(csv.serialized, "name,\nAlice,")
    }

    func testEmptyAndCompletedInputDoNotGainRows() throws {
        XCTAssertEqual(try Parser.array(text: "", delimiter: .comma), [])
        XCTAssertEqual(try Parser.array(text: " \t", delimiter: .comma), [])
        XCTAssertEqual(try Parser.array(text: "value\n", delimiter: .comma), [["value"]])
    }

    func testOffsetsAndLimitsStillExcludeRows() throws {
        XCTAssertEqual(try Parser.array(text: "value", delimiter: .comma, startAt: 1), [])
        XCTAssertEqual(try Parser.array(text: "\"\"", delimiter: .comma, rowLimit: 0), [])
        XCTAssertEqual(try Parser.array(text: "a\n\"\"", delimiter: .comma, rowLimit: 1), [["a"]])
    }
}
