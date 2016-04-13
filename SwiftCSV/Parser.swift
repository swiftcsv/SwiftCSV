//
//  Parser.swift
//  SwiftCSV
//
//  Created by Will Richardson on 11/04/16.
//  Copyright © 2016 JavaNut13. All rights reserved.
//

import Foundation

extension CSV {
    /// List of dictionaries that contains the CSV data
    public var rows: [[String: String]] {
        if _rows == nil {
            parse()
        }
        return _rows!
    }
    
    /// Dictionary of header name to list of values in that column
    /// Will not be loaded if loadColumns in init is false
    public var columns: [String: [String]] {
        if !loadColumns {
            return [:]
        } else if _columns == nil {
            parse()
        }
        return _columns!
    }
    
    /// Parse the file and call a block for each row, passing it as a dictionary
    public func enumerateAsDict(block: [String: String] -> ()) {
        var first = true
        let enumeratedHeader = header.enumerate()
        
        text.enumerateLines { line, _ in
            if !first {
                let fields = self.parseLine(line)
                var dict = [String: String]()
                for (index, head) in enumeratedHeader {
                    dict[head] = index < fields.count ? fields[index] : ""
                }
                block(dict)
            } else {
                first = false
            }
        }
    }
    
    /// Parse the file and call a block for each row, passing it as an array
    public func enumerateAsArray(block: [String] -> ()) {
        var first = true
        text.enumerateLines { line, _ in
            if !first {
                block(self.parseLine(line))
            } else {
                first = false
            }
        }
    }
    
    private func parse() {
        var rows = [[String: String]]()
        var columns = [String: [String]]()
        
        if loadColumns {
            for head in header {
                columns[head] = []
            }
        }
        
        enumerateAsDict { fields in
            if self.loadColumns {
                for (key, value) in fields {
                    columns[key]?.append(value)
                }
            }
            rows.append(fields)
        }
        _rows = rows
        _columns = columns
    }
    
    func parseLine(line: String) -> [String] {
        let escape: Character = "\\"
        let quote: Character = "\""
        
        var fields = [String]()
        
        var inQuotes = false
        var currentIndex = line.startIndex
        
        var field = [Character]()
        
        while currentIndex < line.endIndex {
            let char = line[currentIndex]
            if !inQuotes && char == self.delimiter {
                fields.append(String(field))
                field = [Character]()
            } else {
                if char == quote {
                    inQuotes = !inQuotes
                } else if char == escape {
                    currentIndex = currentIndex.successor()
                    field.append(line[currentIndex])
                } else {
                    field.append(char)
                }
            }
            currentIndex = currentIndex.successor()
        }
        fields.append(String(field))
        
        return fields
    }
}
