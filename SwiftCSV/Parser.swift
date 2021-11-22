//
//  Parser.swift
//  SwiftCSV
//
//  Created by Will Richardson on 13/04/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

extension CSV {
    /// Parse the file and call a block on each row, passing it in as a list of fields
    /// limitTo will limit the result to a certain number of lines
    public func enumerateAsArray(limitTo: Int? = nil, startAt: Int = 0, _ rowCallback: @escaping ([String]) -> ()) throws {

        try Parser.enumerateAsArray(text: self.text, delimiter: self.delimiter, limitTo: limitTo, startAt: startAt, rowCallback: rowCallback)
    }

    public func enumerateAsDict(_ block: @escaping ([String : String]) -> ()) throws {

        try Parser.enumerateAsDict(header: self.header, content: self.text, delimiter: self.delimiter, block: block)
    }
}

enum Parser {

    static func array(text: String, delimiter: Character, limitTo limit: Int? = nil, startAt offset: Int = 0) throws -> [[String]] {

        var rows = [[String]]()

        try enumerateAsArray(text: text, delimiter: delimiter, limitTo: limit, startAt: offset) { row in
            rows.append(row)
        }

        return rows
    }

    /// Parse the text and call a block on each row, passing it in as a list of fields.
    ///
    /// - parameter text: Text to parse.
    /// - parameter delimiter: Character to split row and header fields by (default is ',')
    /// - parameter limit: If set to non-nil value, enumeration stops at the row with index `limitTo`
    ///   (or on end-of-text, whichever comes first). Values below 0 are ignored.
    /// - parameter offset: Offset of rows to ignore before invoking `rowCallback` for the first time. Default is 0.
    /// - parameter rowCallback: Callback invoked for every parsed row between `startAt` and `limitTo` in `text`.
    static func enumerateAsArray(text: String,
                                 delimiter: Character,
                                 limitTo limit: Int? = nil,
                                 startAt offset: Int = 0,
                                 rowCallback: @escaping ([String]) -> ()) throws {
        // Ignore values <0
        let limit = limit.flatMap { $0 < 0 ? nil : $0 }

        var currentIndex = text.startIndex
        let endIndex = text.endIndex

        var fields = [String]()
        var field = ""

        var rowNumber = 0

        func finishRow() {
            defer {
                rowNumber += 1
                fields = []
                field = ""
            }

            guard rowNumber >= offset else { return }
            fields.append(String(field))
            rowCallback(fields)
        }

        var state: ParsingState = ParsingState(
            delimiter: delimiter,
            finishRow: finishRow,
            appendChar: {
                guard rowNumber >= offset else { return }
                field.append($0)
            },
            finishField: {
                guard rowNumber >= offset else { return }
                fields.append(field)
                field = ""
            })

        func limitReached(_ rowNumber: Int) -> Bool {
            guard let limit = limit,
                rowNumber > limit
            else { return false }

            return true
        }

        while currentIndex < endIndex,
              !limitReached(rowNumber) {
            let char = text[currentIndex]

            try state.change(char)

            currentIndex = text.index(after: currentIndex)
        }

        // Append remainder of the cache, unless we're past the limit already.
        if !limitReached(rowNumber) {
            if !field.isEmpty {
                fields.append(field)
            }

            if !fields.isEmpty {
                rowCallback(fields)
            }
        }
    }

    static func enumerateAsDict(header: [String], content: String, delimiter: Character, limitTo limit: Int? = nil, block: @escaping ([String : String]) -> ()) throws {

        let enumeratedHeader = header.enumerated()

        // Start after the header
        try enumerateAsArray(text: content, delimiter: delimiter, limitTo: limit, startAt: 1) { fields in
            var dict = [String: String]()
            for (index, head) in enumeratedHeader {
                dict[head] = index < fields.count ? fields[index] : ""
            }
            block(dict)
        }
    }
}
