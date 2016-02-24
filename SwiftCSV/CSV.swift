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
    
    public private(set) var header: [String] = []
    public private(set) var rows: [[String: String]] = []
    public private(set) var columns: [String: [String]] = [:]
    
    public init(string: String, delimiter: NSCharacterSet = comma) {
        let headerSequence = HeaderSequence(text: string, delimiter: delimiter)
        for fieldName in headerSequence {
            header.append(fieldName)
            columns[fieldName] = []
        }
        
        for row in RowSequence(text: string) {
            var fields: [String: String] = [:]
            for (fieldIndex, field) in FieldSequence(text: row, headerSequence: headerSequence).enumerate() {
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
    
    public func dataUsingEncoding(encoding: NSStringEncoding) -> NSData? {
        return description.dataUsingEncoding(encoding)
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