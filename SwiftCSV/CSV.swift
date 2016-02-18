//
//  CSV.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

public class CSV {
    internal(set) var header: [String] = []
    internal(set) var rows: [[String: String]] = []
    internal(set) var columns: [String: [String]] = [:]
    
    public init(url: NSURL) throws {
        guard var contents = try? String(contentsOfURL: url) else {
            throw CSVError.FileNotFound(url.absoluteString)
        }
        
        let newline = NSCharacterSet(charactersInString: "\n")
        contents = contents.stringByTrimmingCharactersInSet(newline)
        
        for fieldName in HeaderSequence(text: contents) {
            header.append(fieldName)
            columns[fieldName] = []
        }
        
        for (rowIndex, row) in RowSequence(text: contents).enumerate() {
            if rowIndex == 0 {
                continue
            }
            
            var fields: [String: String] = [:]
            for (fieldIndex, field) in FieldSequence(text: row).enumerate() {
                let fieldName = header[fieldIndex]
                fields[fieldName] = field
                columns[fieldName]?.append(field)
            }
            rows.append(fields)
        }
    }
}
