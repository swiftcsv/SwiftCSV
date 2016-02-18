//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation

//public class CSV {
//    public var headers: [String] = []
//    public var rows: [Dictionary<String, String>] = []
//    public var columns = Dictionary<String, [String]>()
//    var delimiter = NSCharacterSet(charactersInString: ",")
//    
//    public init?(contentsOfFile file: String, delimiter: NSCharacterSet, encoding: UInt, error: NSErrorPointer) {
//        let csvString : String
//        do {
//            csvString = try String(contentsOfFile: file);
//            let csvStringToParse = csvString
//            self.delimiter = delimiter
//            
//            let newline = NSCharacterSet.newlineCharacterSet()
//            var lines: [String] = []
//            csvStringToParse.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line) }
//            
//            self.headers = self.parseHeaders(fromLines: lines)
//            self.rows = self.parseRows(fromLines: lines)
//            self.columns = self.parseColumns(fromLines: lines)
//        }
//        catch {
//            csvString = ""
//        }
//        
//    }
//    
//    public init?(contentsOfHTTPURL url: String, encoding: UInt, error: NSErrorPointer) {
//        let csvString : String
//        do {
//            csvString = try String(contentsOfURL: NSURL(string: url)!)
//            let csvStringToParse = csvString
//            
//            let newline = NSCharacterSet.newlineCharacterSet()
//            var lines: [String] = []
//            csvStringToParse.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line) }
//            
//            self.headers = self.parseHeaders(fromLines: lines)
//            self.rows = self.parseRows(fromLines: lines)
//            self.columns = self.parseColumns(fromLines: lines)
//        }
//        catch {
//            csvString = ""
//        }
//    }
//    
//    public convenience init?(contentsOfFile file: String, error: NSErrorPointer) {
//        let comma = NSCharacterSet(charactersInString: ",")
//        self.init(contentsOfFile: file, delimiter: comma, encoding: NSUTF8StringEncoding, error: error)
//    }
//    
//    public convenience init?(contentsOfURL file: String, encoding: UInt, error: NSErrorPointer) {
//        let comma = NSCharacterSet(charactersInString: ",")
//        self.init(contentsOfFile: file, delimiter: comma, encoding: encoding, error: error)
//    }
//    
//    func parseHeaders(fromLines lines: [String]) -> [String] {
//        return lines[0].componentsSeparatedByCharactersInSet(self.delimiter)
//    }
//    
//    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
//        var rows: [Dictionary<String, String>] = []
//        
//        for (lineNumber, line) in lines.enumerate() {
//            if lineNumber == 0 {
//                continue
//            }
//            
//            var row = Dictionary<String, String>()
//            let values = line.componentsSeparatedByCharactersInSet(self.delimiter)
//            for (index, header) in self.headers.enumerate() {
//                if index < values.count {
//                    row[header] = values[index]
//                } else {
//                    row[header] = ""
//                }
//            }
//            rows.append(row)
//        }
//        
//        return rows
//    }
//    
//    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
//        var columns = Dictionary<String, [String]>()
//        
//        for header in self.headers {
//            let column = self.rows.map { row in row[header] != nil ? row[header]! : "" }
//            columns[header] = column
//        }
//        
//        return columns
//    }
//    
//    public func toString(del:String = ",") -> String{
//        var string = ""
//        let headersCount = self.headers.count
//        for (i, header) in enumerate(self.headers){
//            if i < headersCount - 1 && headersCount != 1 {
//                string += "\(header)\(del)"
//            }else{
//                string += "\(header)"
//            }
//        }
//        string += "\n"
//        for (i, row) in enumerate(self.rows) {
//            for (j, header) in enumerate(self.headers) {
//                var value = row[header]
//                if value == nil {
//                    value = ""
//                }
//                if j < headersCount - 1 && headersCount != 1 {
//                    string += "\(value!)\(del)"
//                }else{
//                    string += "\(value!)"
//                }
//            }
//            string += "\n"
//        }
//        return string
//    }
//}
