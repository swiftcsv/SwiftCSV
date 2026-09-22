import XCTest
@testable import SwiftCSV

class SerializationNewlineTests: XCTestCase {
    func testLineBreaksRemainQuotedForEnumeratedRoundTrip() throws {
        for newline in ["\n", "\r", "\r\n"] {
            for delimiter: CSVDelimiter in [.comma, .semicolon, .tab, .character("|")] {
                let separator = String(delimiter.rawValue)
                let source = "\"first\(newline)name\"\(separator)second\n\"value\(newline)continued\"\(separator)other"
                let original = try EnumeratedCSV(string: source, delimiter: delimiter)
                XCTAssertEqual(original.serialized, source)
                let decoded = try EnumeratedCSV(string: original.serialized, delimiter: delimiter)
                XCTAssertEqual(decoded.header, original.header)
                XCTAssertEqual(decoded.rows, original.rows)
            }
        }
    }

    func testLineBreaksRemainQuotedForNamedRoundTrip() throws {
        for newline in ["\n", "\r", "\r\n"] {
            let source = "name,note\nAlice,\"first\(newline)second\""
            let original = try NamedCSV(string: source, delimiter: .comma)
            XCTAssertEqual(original.serialized, source)
            let decoded = try NamedCSV(string: original.serialized, delimiter: .comma)
            XCTAssertEqual(decoded.rows, original.rows)
        }
    }
}
