//
//  EnumeratedCSVView.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 25/10/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

public struct Enumerated: CSVView {

    public struct Column: Equatable {
        public let header: String
        public let rows: [String]
    }

    public typealias Row = [String]

    public private(set) var rows: [Row]
    public private(set) var columns: [Column]

    public init(header: [String], text: String, delimiter: CSVDelimiter, loadColumns: Bool = false, rowLimit: Int? = nil) throws {
        var rows = [[String]]()
        var columns: [Enumerated.Column] = []

        try Parser.enumerateAsArray(text: text, delimiter: delimiter, startAt: 1, rowLimit: rowLimit) { fields in
            rows.append(fields)
        }

        // Fill in gaps at the end of rows that are too short.
        rows = makingRectangular(rows: rows)

        if loadColumns {
            columns = header.enumerated().map { (index: Int, header: String) -> Enumerated.Column in
                return Enumerated.Column(
                    header: header,
                    rows: rows.map { $0[safe: index] ?? "" })
            }
        }

        self.rows = rows
        self.columns = columns
    }

    public func serialize(header: [String], delimiter: CSVDelimiter) -> String {
        let separator = String(delimiter.rawValue)

        let head = header
            .map(enquoteContentsIfNeeded(cell:))
            .joined(separator: separator) + "\n"

        let content = rows.map { row in
            row.map(enquoteContentsIfNeeded(cell:))
                .joined(separator: separator)
        }.joined(separator: "\n")

        return head + content
    }
}

extension Collection {
    subscript (safe index: Self.Index) -> Self.Iterator.Element? {
        return index < endIndex ? self[index] : nil
    }
}

fileprivate func makingRectangular(rows: [[String]]) -> [[String]] {
    let cellsPerRow = rows.map { $0.count }.max() ?? 0
    return rows.map { row -> [String] in
        let missingCellCount = cellsPerRow - row.count 
        let appendix = Array(repeating: "", count: missingCellCount)
        return row + appendix
    }
}
