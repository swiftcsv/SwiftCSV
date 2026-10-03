import XCTest
@testable import SwiftCSV

final class DuplicateHeaderTests: XCTestCase {
    private let text = """
    en,comment,de,en,en-GB,fr,es,it
    ,,,,,,,
    Efficiency,,,,,,,
    %@,,,,,,,
    """

    func testNamedViewRejectsDuplicateHeaders() {
        XCTAssertThrowsError(try CSV<Named>(string: text)) { error in
            guard case CSVParseError.duplicateHeader(name: "en") = error else {
                return XCTFail("Expected a duplicate-header error, got \(error)")
            }
        }
    }

    func testEnumeratedViewPreservesDuplicateHeaderColumns() throws {
        let csv = try CSV<Enumerated>(string: text)

        XCTAssertEqual(csv.header, ["en", "comment", "de", "en", "en-GB", "fr", "es", "it"])
        XCTAssertEqual(csv.rows[1], ["Efficiency", "", "", "", "", "", "", ""])
        XCTAssertEqual(csv.columns?.filter { $0.header == "en" }.count, 2)
    }

    func testDictionaryEnumerationRejectsDuplicateHeaders() throws {
        let csv = try CSV<Enumerated>(string: text)

        XCTAssertThrowsError(try csv.enumerateAsDict { _ in }) { error in
            guard case CSVParseError.duplicateHeader(name: "en") = error else {
                return XCTFail("Expected a duplicate-header error, got \(error)")
            }
        }
    }
}
