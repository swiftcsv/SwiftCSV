//
//  Serializer.swift
//  SwiftCSV
//

import Foundation

enum Serializer {

    static func serialize(header: [String], rows: [[String]], delimiter: CSVDelimiter) -> String {
        let head = serializeRow(row: header, delimiter: delimiter) + "\n"

        let content = rows.map { row in
            serializeRow(row: row, delimiter: delimiter)
        }.joined(separator: "\n")

        return head + content
    }


    static func serializeRow(row: [String], delimiter: CSVDelimiter) -> String {
        let separator = String(delimiter.rawValue)
        let curry = { cell in enquoteContents(of: cell, containing: separator) }

        let content = row
            .map(curry)
            .joined(separator: separator)

        return content
    }


    static func enquoteContents(of cell: String, containing separator: String) -> String {
        // Add quotes if value contains a delimiter
        if cell.contains(separator) {
            return "\"\(cell)\""
        }
        return cell
    }

}
