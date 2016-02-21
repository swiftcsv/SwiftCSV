//
//  CSV.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

public class CSV {
    static private let comma = NSCharacterSet(charactersInString: ",")
    static private let newline = NSCharacterSet.newlineCharacterSet()
    
    internal(set) var header: [String] = []
    internal(set) var rows: [[String: String]] = []
    internal(set) var columns: [String: [String]] = [:]
    
    public init(string: String, delimiter: NSCharacterSet = comma) {
        let trimmedContents = string.stringByTrimmingCharactersInSet(CSV.newline)
        
        for fieldName in HeaderSequence(text: trimmedContents, delimiter: delimiter) {
            header.append(fieldName)
            columns[fieldName] = []
        }
        
        for (rowIndex, row) in RowSequence(text: trimmedContents).enumerate() {
            if rowIndex == 0 {
                continue
            }
            
            var fields: [String: String] = [:]
            for (fieldIndex, field) in FieldSequence(text: row, delimiter: delimiter).enumerate() {
                let fieldName = header[fieldIndex]
                fields[fieldName] = field
                columns[fieldName]?.append(field)
            }
            rows.append(fields)
        }
    }
    
    public convenience init(name: String, delimiter: NSCharacterSet = comma, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
        var contents: String!
        do {
            contents = try String(contentsOfFile: name, encoding: encoding)
        } catch {
            throw error
        }
        
        self.init(string: contents, delimiter: delimiter)
    }
    
    public convenience init(url: NSURL, delimiter: NSCharacterSet = comma, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
        var contents: String!
        do {
            contents = try String(contentsOfURL: url, encoding: encoding)
        } catch {
            throw error
        }
        
        self.init(string: contents, delimiter: delimiter)
    }
}

extension CSV: CustomStringConvertible {
    public var description: String {
        var contents = header.joinWithSeparator(",")
        
        for row in rows {
            contents += "\n"
            
            let fields = header.map { row[$0]! }
            contents += fields.joinWithSeparator(",")
        }
        
        return contents
    }
}