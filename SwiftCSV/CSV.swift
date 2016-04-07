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
    public private(set) var rows: [[String: String]] = []
    public private(set) var columns: [String: [String]] = [:]
    
    public init(string: String, delimiter: Character = comma) {
        let headerSequence = HeaderSequence(text: string, delimiter: delimiter)
        for fieldName in headerSequence {
            header.append(fieldName)
            columns[fieldName] = []
        }
        
        for row in RowSequence(text: string) {
            var fields: [String: String] = [:]
            autoreleasepool {
                for (fieldIndex, field) in FieldSequence(text: row, headerSequence: headerSequence).enumerate() {
                    let fieldName = header[fieldIndex]
                    fields[fieldName] = field
                    columns[fieldName]?.append(field)
                }
            }
            rows.append(fields)
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

extension CSV: CustomStringConvertible {
    public var description: String {
        let head = header.joinWithSeparator(",") + "\n"
        
        let cont = rows.map { row in
            header.map { row[$0]! }.joinWithSeparator(",")
        }.joinWithSeparator("\n")
        return head + cont
    }
}
