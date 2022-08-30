//
//  Serializer.swift
//  SwiftCSV
//

import Foundation

enum Serializer {

    static let newline = "\n"

    static func serialize(header: [String], rows: [[String]], delimiter: CSVDelimiter) -> String {
        let head = serializeRow(row: header, delimiter: delimiter) + newline

        let content = rows.map { row in
            serializeRow(row: row, delimiter: delimiter)
        }.joined(separator: newline)

        return head + content
    }


    static func serializeRow(row: [String], delimiter: CSVDelimiter) -> String {
        let separator = String(delimiter.rawValue)

        let content = row.map { cell in
            cell.enquoted(whenContaining: separator)
        }.joined(separator: separator)

        return content
    }

}

fileprivate extension String {

    static let quote = "\""

    func enquoted(whenContaining separator: String) -> String {
        // If value contains a delimiter or quotes, double any embedded quotes and surround with quotes.
        // For more information, see https://www.rfc-editor.org/rfc/rfc4180.html
        if self.contains(separator) || self.contains(Self.quote) {
            return Self.quote + self.replacingOccurrences(of: Self.quote, with: Self.quote + Self.quote) + Self.quote
        } else {
            return self
        }
    }

}
