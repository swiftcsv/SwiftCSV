//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation

public class CSV {
    public var headers: [String] = []
    public var rows: [Dictionary<String, String>] = []
    public var columns = Dictionary<String, [String]>()
    var delimiter = NSCharacterSet(charactersInString: ",")
    
    public init(content: String?, delimiter: NSCharacterSet, encoding: UInt) throws{
        if let csvStringToParse = content{
            self.delimiter = delimiter

            let newline = NSCharacterSet.newlineCharacterSet()
            var lines: [String] = []
            csvStringToParse.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line) }

            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
            self.columns = self.parseColumns(fromLines: lines)
        }
    }
    
    public convenience init(contentsOfURL url: NSURL, delimiter: NSCharacterSet, encoding: UInt) throws {
        let csvString: String?
        do {
            csvString = try String(contentsOfURL: url, encoding: encoding)
        } catch _ {
            csvString = nil
        };
        try self.init(content: csvString,delimiter:delimiter, encoding:encoding)
    }
    
    public convenience init(contentsOfURL url: NSURL) throws {
        let comma = NSCharacterSet(charactersInString: ",")
        try self.init(contentsOfURL: url, delimiter: comma, encoding: NSUTF8StringEncoding)
    }
    
    public convenience init(contentsOfURL url: NSURL, encoding: UInt) throws {
        let comma = NSCharacterSet(charactersInString: ",")
        try self.init(contentsOfURL: url, delimiter: comma, encoding: encoding)
    }
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].componentsSeparatedByCharactersInSet(self.delimiter)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows: [Dictionary<String, String>] = []
        
        for (lineNumber, line) in lines.enumerate() {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, String>()
            let values = line.componentsSeparatedByCharactersInSet(self.delimiter)
            for (index, header) in self.headers.enumerate() {
                if index < values.count {
                    row[header] = values[index]
                } else {
                    row[header] = ""
                }
            }
            rows.append(row)
        }
        
        return rows
    }
    
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header] != nil ? row[header]! : "" }
            columns[header] = column
        }
        
        return columns
    }
}
