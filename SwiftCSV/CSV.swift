//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import UIKit

class CSV {
    let separator = ","
    let headers: [String] = []
    let rows: [Dictionary<String, AnyObject?>] = []
    let columns = Dictionary<String, [AnyObject?]>()
    
    init(contentsOfURL url: NSURL, separator: String) {
        var error: NSError?
        let csvString = String.stringWithContentsOfURL(url, encoding: NSUTF8StringEncoding, error: &error)
        if let csvStringToParse = csvString {
            self.separator = separator
            
            let lines = csvStringToParse.componentsSeparatedByString("\n")
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
            self.columns = self.parseColumns(fromLines: lines)
        } else {
            NSLog("Failed to open file: \(error)")
            abort()
        }
    }
    
    convenience init(contentsOfURL url: NSURL) {
        self.init(contentsOfURL: url, separator: ",")
    }
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].componentsSeparatedByString(self.separator)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, AnyObject?>] {
        var rows: [Dictionary<String, AnyObject?>] = []
        
        for (lineNumber, line) in enumerate(lines) {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, AnyObject?>()
            let values = line.componentsSeparatedByString(self.separator)
            for (index, header) in enumerate(self.headers) {
                let value = values[index]
                if let intValue = value.toInt() {
                    row[header] = intValue
                } else if value == "true" {
                    row[header] = true
                } else if value == "false" {
                    row[header] = false
                } else {
                    row[header] = value
                }
            }
            rows.append(row)
        }
        
        return rows
    }
    
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [AnyObject?]> {
        var columns = Dictionary<String, [AnyObject?]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header]! }
            columns[header] = column
        }
        
        return columns
    }
}
