//
//  Parser.swift
//  SwiftCSV
//
//  Created by Will Richardson on 13/04/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

fileprivate extension Character {
    var isNewline: Bool {
        return self == "\n" || self == "\r\n"
    }
}

extension CSV {
    /// Parse the file and call a block on each row, passing it in as a list of fields
    /// limitTo will limit the result to a certain number of lines
    func enumerateAsArray(_ block: @escaping ([String]) -> (), limitTo: Int?, startAt: Int = 0) {

        CSV.enumerateAsArray(text: self.text, delimiter: self.delimiter, limitTo: limitTo, startAt: startAt, block: block)
    }

    static func array(text: String, delimiter: Character, limitTo: Int? = nil, startAt: Int = 0) -> [[String]] {

        var rows = [[String]]()

        enumerateAsArray(text: text, delimiter: delimiter) { row in
            rows.append(row)
        }

        return rows
    }

    /// Parse the text and call a block on each row, passing it in as a list of fields.
    ///
    /// - parameter text: Text to parse.
    /// - parameter delimiter: Character to split row and header fields by (default is ',')
    /// - parameter limitTo: If set to non-nil value, enumeration stops 
    ///   at the row with index `limitTo` (or on end-of-text, whichever is earlier.
    /// - parameter startAt: Offset of rows to ignore before invoking `block` for the first time. Default is 0.
    /// - parameter block: Callback invoked for every parsed row between `startAt` and `limitTo` in `text`.
    static func enumerateAsArray(text: String, delimiter: Character, limitTo: Int? = nil, startAt: Int = 0, block: @escaping ([String]) -> ()) {
        var currentIndex = text.startIndex
        let endIndex = text.endIndex

        var atStart = true
        var parsingField = false
        var parsingQuotes = false
        var innerQuotes = false

        var fields = [String]()
        var field = ""

        var count = 0

        func finishRow() {
            fields.append(String(field))
            if count >= startAt {
                block(fields)
            }
            count += 1
            fields = [String]()
            field = ""
        }

        func changeState(_ char: Character) {
            if atStart {
                if char == "\"" {
                    atStart = false
                    parsingQuotes = true
                } else if char == delimiter {
                    fields.append(field)
                    field = ""
                } else if char.isNewline {
                    finishRow()
                } else {
                    parsingField = true
                    atStart = false
                    field.append(char)
                }
            } else if parsingField {
                if innerQuotes {
                    if char == "\"" {
                        field.append(char)
                        innerQuotes = false
                    } else {
                        fatalError("Can't have non-quote here: \(char)")
                    }
                } else {
                    if char == "\"" {
                        innerQuotes = true
                    } else if char == delimiter {
                        atStart = true
                        parsingField = false
                        innerQuotes = false
                        fields.append(field)
                        field = ""
                    } else if char.isNewline {
                        atStart = true
                        parsingField = false
                        innerQuotes = false
                        finishRow()
                    } else {
                        field.append(char)
                    }
                }
            } else if parsingQuotes {
                if innerQuotes {
                    if char == "\"" {
                        field.append(char)
                        innerQuotes = false
                    } else if char == delimiter {
                        atStart = true
                        parsingField = false
                        innerQuotes = false
                        fields.append(field)
                        field = ""
                    } else if char.isNewline {
                        atStart = true
                        parsingQuotes = false
                        innerQuotes = false
                        finishRow()
                    } else {
                        fatalError("Can't have non-quote here: \(char)")
                    }
                } else {
                    if char == "\"" {
                        innerQuotes = true
                    } else {
                        field.append(char)
                    }
                }
            } else {
                fatalError("me_irl")
            }
        }

        func limitReached(_ count: Int) -> Bool {

            guard let limitTo = limitTo,
                count >= limitTo
                else { return false }

            return true
        }

        while currentIndex < endIndex {
            let char = text[currentIndex]

            changeState(char)

            if limitReached(count) {
                break
            }

            currentIndex = text.index(after: currentIndex)
        }

        if !fields.isEmpty || !field.isEmpty || limitReached(count) {
            fields.append(field)
            block(fields)
        }
    }

}
