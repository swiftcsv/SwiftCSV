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
    
    /// Load a CSV file from a string
    ///
    /// string: string data of the CSV file
    /// delimiter: character to split row and header fields by (default is ',')
    /// loadColumns: whether to populate the columns dictionary (default is true)
    public init(string: String, delimiter: Character = comma, loadColumns: Bool = true) {
        self.text = string
        self.delimiter = delimiter
        self.loadColumns = loadColumns
        
        let createHeader: [String] -> () = { head in
            self.header = head
        }
        enumerateAsArray(createHeader, limitTo: 1, startAt: 0)
    }
    
    /// Load a CSV file
    ///
    /// name: name of the file (will be passed to String(contentsOfFile:encoding:) to load)
    /// delimiter: character to split row and header fields by (default is ',')
    /// encoding: encoding used to read file (default is NSUTF8StringEncoding)
    /// loadColumns: whether to populate the columns dictionary (default is true)
    public convenience init(name: String, delimiter: Character = comma, encoding: NSStringEncoding = NSUTF8StringEncoding, loadColumns: Bool = true) throws {
        let contents = try String(contentsOfFile: name, encoding: encoding)
    
        self.init(string: contents, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    /// Load a CSV file from a URL
    ///
    /// url: url pointing to the file (will be passed to String(contentsOfURL:encoding:) to load)
    /// delimiter: character to split row and header fields by (default is ',')
    /// encoding: encoding used to read file (default is NSUTF8StringEncoding)
    /// loadColumns: whether to populate the columns dictionary (default is true)
    public convenience init(url: NSURL, delimiter: Character = comma, encoding: NSStringEncoding = NSUTF8StringEncoding, loadColumns: Bool = true) throws {
        let contents = try String(contentsOfURL: url, encoding: encoding)
        
        self.init(string: contents, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    /// Turn the CSV data into NSData using a given encoding
    public func dataUsingEncoding(encoding: NSStringEncoding) -> NSData? {
        return description.dataUsingEncoding(encoding)
    }
}
