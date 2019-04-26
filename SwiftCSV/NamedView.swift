//
//  NamedView.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 22/10/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

public struct NamedView: View {

    public typealias Row = [String : String]

    public var rows: [Row]
    public var columns: [String : [String]]

    public init(header: [String], text: String, delimiter: Character, loadColumns: Bool = false) throws {

        var rows = [[String: String]]()
        var columns = [String: [String]]()

        try Parser.enumerateAsDict(header: header, content: text, delimiter: delimiter) { dict in
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

        let head = header.joined(separator: ",") + "\n"

        let content = rows.map { row in
            header.map { row[$0]! }.joined(separator: ",")
        }.joined(separator: "\n")

        return head + content
    }
}
