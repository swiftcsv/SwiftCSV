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
    
    public private(set) var header: [String] = []
    private var _rows: [[String: String]]? = nil
    private var _columns: [String: [String]]? = nil
    
    private var text: String
    private var delimiter: Character
    
    public init(string: String, delimiter: Character = comma) {
        text = string
        self.delimiter = delimiter
        
        let headerSequence = HeaderSequence(text: text, delimiter: delimiter)
        for fieldName in headerSequence {
            header.append(fieldName)
        }
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
        if _columns == nil {
            parse()
        }
        return _columns!
    }
    
    public func enumerateRows(block: [String: String] -> ()) {
        var first = true
        self.text.enumerateLines { line, _ in
            if !first {
                block(self.parseLineAsDict(line))
            } else {
                first = false
            }
        }
    }
    
    private func parse() {
        let rows = [[String: String]]()
        let columns = [String: [String]]()
//
//        for head in header {
//            columns[head] = []
//        }
//        
//        for row in RowSequence(text: text) {
//            var fields: [String: String] = [:]
//            autoreleasepool {
//                for (fieldIndex, field) in FieldSequence(text: row, headerSequence: headerSequence).enumerate() {
//                    let fieldName = header[fieldIndex]
//                    fields[fieldName] = field
//                    columns[fieldName]?.append(field)
//                }
//            }
//            rows.append(fields)
//        }
        _rows = rows
        _columns = columns
    }
    
    private func parseLineAsDict(line: String) -> [String: String] {
        let escape: Character = "\\"
        let quote: Character = "\""
        let quoteCharSet = NSCharacterSet(charactersInString: "\"")
        
        var fields = [String: String]()
        
        var inQuotes = false
        var lastIndex = line.startIndex
        var currentIndex = line.startIndex
        var position = 0
        
        while currentIndex < line.endIndex {
            let char = line[currentIndex]
            if !inQuotes && char == self.delimiter {
                let field = line.substringWithRange(lastIndex..<currentIndex)
                // TODO it would be nice to not trim this
                let value = field.stringByTrimmingCharactersInSet(quoteCharSet)
                
                let head = header[position]
                fields[head] = value
                position += 1
                if position >= header.count {
                    break
                }
                lastIndex = currentIndex.advancedBy(1)
            }
            if char == quote {
                inQuotes = !inQuotes
            }
            currentIndex = currentIndex.advancedBy(char == escape ? 2 : 1)
        }
        if position < header.count {
            let value = line.substringWithRange(lastIndex..<currentIndex).stringByTrimmingCharactersInSet(quoteCharSet)
            
            let head = header[position]
            fields[head] = value
        }
        
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
