//
//  NamedCSVView.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 22/10/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

public struct Named: CSVView {

    public typealias Row = [String : String]
    public typealias Columns = [String : [String]]

    public var rows: [Row]
    public var columns: Columns?

    public init(header: [String], text: String, delimiter: CSVDelimiter, loadColumns: Bool = false, rowLimit: Int? = nil) throws {

        self.rows = try {
            var rows: [Row] = []
            try Parser.enumerateAsDict(header: header, content: text, delimiter: delimiter, rowLimit: rowLimit) { dict in
                rows.append(dict)
            }
            return rows
        }()

        self.columns = {
            guard loadColumns else { return nil }
            var columns: Columns = [:]
            for field in header {
                columns[field] = rows.map { $0[field] ?? "" }
            }
            return columns
        }()
    }

    public func serialize(header: [String], delimiter: CSVDelimiter) -> String {
        let rowsOrderingCellsByHeader = rows.map { row in
            header.map { cellID in row[cellID]! }
        }

        return Serializer.serialize(header: header, rows: rowsOrderingCellsByHeader, delimiter: delimiter)
    }

}
