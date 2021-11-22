//
//  NamedCSVView.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 22/10/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

public struct Named: CSVView {

    public typealias Row = [String : String]

    public var rows: [Row]
    public var columns: [String : [String]]

    public init(header: [String], text: String, delimiter: Character, loadColumns: Bool = false, rowLimit: Int? = nil) throws {

        var rows = [[String: String]]()
        var columns = [String: [String]]()

        try Parser.enumerateAsDict(header: header, content: text, delimiter: delimiter, rowLimit: rowLimit) { dict in
            rows.append(dict)
        }

        if loadColumns {
            for field in header {
                columns[field] = rows.map { $0[field] ?? "" }
            }
        }

        self.rows = rows
        self.columns = columns
    }

    public func serialize(header: [String], delimiter: Character) -> String {

        let head = header
            .map(enquoteContentsIfNeeded(cell:))
            .joined(separator: ",") + "\n"

        let content = rows.map { row in
            header
                .map { cellID in row[cellID]! }
                .map(enquoteContentsIfNeeded(cell:))
                .joined(separator: ",")
        }.joined(separator: "\n")

        return head + content
    }
}
