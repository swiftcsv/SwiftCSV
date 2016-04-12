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
    
    public var header: [String]!
    var _rows: [[String: String]]? = nil
    var _columns: [String: [String]]? = nil
    
    var text: String
    var delimiter: Character
    
    let loadColumns: Bool
    
    public init(string: String, delimiter: Character = comma, loadColumns: Bool = true) {
        self.text = string
        self.delimiter = delimiter
        self.loadColumns = loadColumns
        
        header = parseLine(text.firstLine)
    }
    
    public convenience init(name: String, delimiter: Character = comma, encoding: NSStringEncoding = NSUTF8StringEncoding, loadColumns: Bool = true) throws {
        let contents = try String(contentsOfFile: name, encoding: encoding)
    
        self.init(string: contents, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    public convenience init(url: NSURL, delimiter: Character = comma, encoding: NSStringEncoding = NSUTF8StringEncoding, loadColumns: Bool = true) throws {
        let contents = try String(contentsOfURL: url, encoding: encoding)
        
        self.init(string: contents, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    public func dataUsingEncoding(encoding: NSStringEncoding) -> NSData? {
        return description.dataUsingEncoding(encoding)
    }
}
