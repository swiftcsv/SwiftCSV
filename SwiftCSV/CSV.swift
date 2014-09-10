//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import UIKit

public class CSV {
    public let headers: [String] = []
    public let rows: [Dictionary<String, String>] = []
    public let columns = Dictionary<String, [String]>()
    let separator = NSCharacterSet(charactersInString: ",")
    
    public init(contentsOfURL url: NSURL, separator: NSCharacterSet) {
        var error: NSError?
        let csvString = String.stringWithContentsOfURL(url, encoding: NSUTF8StringEncoding, error: &error)
        if let csvStringToParse = csvString {
            self.separator = separator
            
            let newline = NSCharacterSet.newlineCharacterSet()
            let lines = csvStringToParse.stringByTrimmingCharactersInSet(newline).componentsSeparatedByCharactersInSet(newline)
            
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
            self.columns = self.parseColumns(fromLines: lines)
        } else {
            NSLog("Failed to open file: \(error)")
            abort()
        }
    }
    
    public convenience init(contentsOfURL url: NSURL) {
        let comma = NSCharacterSet(charactersInString: ",")
        self.init(contentsOfURL: url, separator: comma)
    }
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].componentsSeparatedByCharactersInSet(self.separator)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows: [Dictionary<String, String>] = []
        
        for (lineNumber, line) in enumerate(lines) {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, String>()
            let values = line.componentsSeparatedByCharactersInSet(self.separator)
            for (index, header) in enumerate(self.headers) {
                let value = values[index]
                row[header] = value
            }
            rows.append(row)
        }
        
        return rows
    }
    
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header]! }
            columns[header] = column
        }
        
        return columns
    }
}
