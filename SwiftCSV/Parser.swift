//
//  Parser.swift
//  SwiftCSV
//
//  Created by Will Richardson on 13/04/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

extension CSV {
    /// Parse the file and call a block on each row, passing it in as a list of fields.
    /// - Parameters limitTo: Maximum absolute line number in the content, *not* maximum amount of rows.
    @available(*, deprecated, message: "Use enumerateAsArray(startAt:rowLimit:_:) instead")
    public func enumerateAsArray(limitTo maxRow: Int? = nil, startAt: Int = 0, _ rowCallback: @escaping ([String]) -> ()) throws {

        try Parser.enumerateAsArray(text: self.text, delimiter: self.delimiter, startAt: startAt, rowLimit: maxRow.map { $0 - startAt }, rowCallback: rowCallback)
    }

    /// Parse the CSV contents row by row from `start` for `rowLimit` amount of rows, or until the end of the input.
    /// - Parameters:
    ///   - startAt: Skip lines before this. Default value is `0` to start at the beginning.
    ///   - rowLimit: Amount of rows to consume, beginning to count at `startAt`. Default value is `nil` to consume
    ///     the whole input string.
    ///   - rowCallback: Array of each row's columnar values, in order.
    public func enumerateAsArray(startAt: Int = 0, rowLimit: Int? = nil, _ rowCallback: @escaping ([String]) -> ()) throws {

        try Parser.enumerateAsArray(text: self.text, delimiter: self.delimiter, startAt: startAt, rowLimit: rowLimit, rowCallback: rowCallback)
    }

    public func enumerateAsDict(_ block: @escaping ([String : String]) -> ()) throws {

        try Parser.enumerateAsDict(header: self.header, content: self.text, delimiter: self.delimiter, block: block)
    }
}

enum Parser {

    static func array(text: String, delimiter: CSVDelimiter, startAt offset: Int = 0, rowLimit: Int? = nil) throws -> [[String]] {

        var rows = [[String]]()

        try enumerateAsArray(text: text, delimiter: delimiter, startAt: offset, rowLimit: rowLimit) { row in
            rows.append(row)
        }

        return rows
    }

    /// Parse `text` and provide each row to `rowCallback` as an array of field values, one for each column per
    /// line of text, separated by `delimiter`.
    ///
    /// - Parameters:
    ///   - text: Text to parse.
    ///   - delimiter: Character to split row and header fields by (default is ',')
    ///   - offset: Skip lines before this. Default value is `0` to start at the beginning.
    ///   - rowLimit: Amount of rows to consume, beginning to count at `startAt`. Default value is `nil` to consume
    ///     the whole input string.
    ///   - rowCallback: Callback invoked for every parsed row between `startAt` and `limitTo` in `text`.
    /// - Throws: `CSVParseError`
    static func enumerateAsArray(text: String,
                                 delimiter: CSVDelimiter,
                                 startAt offset: Int = 0,
                                 rowLimit: Int? = nil,
                                 rowCallback: @escaping ([String]) -> ()) throws {
        let maxRowIndex = rowLimit.flatMap { $0 < 0 ? nil : offset + $0 }

        var currentIndex = text.startIndex
        let endIndex = text.endIndex

        var fields = [String]()
        let delimiter = delimiter.rawValue
        var field = ""

        var rowIndex = 0

        func finishRow() {
            defer {
                rowIndex += 1
                fields = []
                field = ""
            }

            guard rowIndex >= offset else { return }
            fields.append(String(field))
            rowCallback(fields)
        }

        var state: ParsingState = ParsingState(
            delimiter: delimiter,
            finishRow: finishRow,
            appendChar: {
                guard rowIndex >= offset else { return }
                field.append($0)
            },
            finishField: {
                guard rowIndex >= offset else { return }
                fields.append(field)
                field = ""
            })

        func limitReached(_ rowNumber: Int) -> Bool {
            guard let maxRowIndex = maxRowIndex else { return false }
            return rowNumber >= maxRowIndex
        }

        while currentIndex < endIndex,
              !limitReached(rowIndex) {
            let char = text[currentIndex]

            try state.change(char)

            currentIndex = text.index(after: currentIndex)
        }

        // Append remainder of the cache, unless we're past the limit already.
        if !limitReached(rowIndex) {
            if !field.isEmpty {
                fields.append(field)
            }

            if !fields.isEmpty {
                rowCallback(fields)
            }
        }
    }

    static func enumerateAsDict(header: [String], content: String, delimiter: CSVDelimiter, rowLimit: Int? = nil, block: @escaping ([String : String]) -> ()) throws {

        let enumeratedHeader = header.enumerated()

        // Start after the header
        try enumerateAsArray(text: content, delimiter: delimiter, startAt: 1, rowLimit: rowLimit) { fields in
            var dict = [String: String]()
            for (index, head) in enumeratedHeader {
                dict[head] = index < fields.count ? fields[index] : ""
            }
            block(dict)
        }
    }
}
