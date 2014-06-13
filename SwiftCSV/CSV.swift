//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import UIKit

class CSV {
    let headers: String[] = []
    let rows: Dictionary<String, AnyObject?>[] = []
    
    init(contentsOfURL url: NSURL) {
        var error: NSError?
        let csvString = String.stringWithContentsOfURL(url, encoding: NSUTF8StringEncoding, error: &error)
        if let csvStringToParse = csvString {
            let lines = csvStringToParse.componentsSeparatedByString("\n")
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
        } else {
            NSLog("Failed to open file: \(error)")
            abort()
        }
    }
    
    func parseHeaders(fromLines lines: String[]) -> String[] {
        return lines[0].componentsSeparatedByString(",")
    }
    
    func parseRows(fromLines lines: String[]?) -> Dictionary<String, AnyObject?>[] {
        var rows: Dictionary<String, AnyObject?>[] = []
        
        if let linesToParse = lines {
            for (lineNumber, line) in enumerate(linesToParse) {
                if lineNumber == 0 {
                    continue
                }
                
                var row = Dictionary<String, AnyObject?>()
                let values = line.componentsSeparatedByString(",")
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
        }
        
        return rows
    }
}
