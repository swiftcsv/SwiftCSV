//
//  CSV.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

public class CSV {
    static private let comma: Character = ","
    
    public var header: [String]!
    private var _rows: [[String: String]]? = nil
    private var _columns: [String: [String]]? = nil
    
    private var text: String
    private var delimiter: Character
    
    private let ignoreColumns: Bool
    
    public init(string: String, delimiter: Character = comma, ignoreColumns: Bool = false) {
        self.text = string
        self.delimiter = delimiter
        self.ignoreColumns = ignoreColumns
        
        header = parseLine(text.getLines(1)[0])
    }
    
    public convenience init(name: String, delimiter: Character = comma, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
        let contents = try String(contentsOfFile: name, encoding: encoding)
    
        self.init(string: contents, delimiter: delimiter)
    }
    
    public convenience init(url: NSURL, delimiter: Character = comma, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
        let contents = try String(contentsOfURL: url, encoding: encoding)
        
        self.init(string: contents, delimiter: delimiter)
    }
    
    public func dataUsingEncoding(encoding: NSStringEncoding) -> NSData? {
        return description.dataUsingEncoding(encoding)
    }
}

extension CSV {
    public var rows: [[String: String]] {
        if _rows == nil {
            parse()
        }
        return _rows!
    }
    public var columns: [String: [String]] {
        if ignoreColumns {
            return [:]
        } else if _columns == nil {
            parse()
        }
        return _columns!
    }
    
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

        if !ignoreColumns {
            for head in header {
                columns[head] = []
            }
        }
        
        enumerateAsDict { fields in
            if !self.ignoreColumns {
                for (key, value) in fields {
                    columns[key]?.append(value)
                }
            }
            rows.append(fields)
        }
        _rows = rows
        _columns = columns
    }
    
    private func parseLine(line: String) -> [String] {
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

extension CSV: CustomStringConvertible {
    public var description: String {
        let head = header.joinWithSeparator(",") + "\n"
        
        let cont = rows.map { row in
            header.map { row[$0]! }.joinWithSeparator(",")
        }.joinWithSeparator("\n")
        return head + cont
    }
}
