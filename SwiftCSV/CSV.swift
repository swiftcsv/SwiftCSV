//
//  CSV.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

public protocol View {
    associatedtype Row
    associatedtype Columns

    var rows: [Row] { get }
    var columns: Columns { get }

    init(header: [String], text: String, delimiter: Character, loadColumns: Bool) throws

    func serialize(header: [String], delimiter: Character) -> String
}

open class CSV<DataView : View>  {
    public static var comma: Character { return "," }
    
    public let header: [String]

    let text: String
    let delimiter: Character

    let content: DataView

    public var rows: [DataView.Row] {
        return content.rows
    }

    public var columns: DataView.Columns {
        return content.columns
    }

    
    /// Load a CSV file from a string
    ///
    /// - parameter string: Contents of the CSV file
    /// - parameter delimiter: Character to split row and header fields by (default is ',')
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is true)
    /// - throws: CSVParseError when parsing `string` fails.
    public init(string: String, delimiter: Character = comma, loadColumns: Bool = true) throws {
        self.text = string
        self.delimiter = delimiter
        self.header = try Parser.array(text: string, delimiter: delimiter, limitTo: 1).first ?? []

        self.content = try DataView.init(header: header, text: text, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    /// Load a CSV file
    ///
    /// - parameter name: name of the file (will be passed to String(contentsOfFile:encoding:) to load)
    /// - parameter delimiter: character to split row and header fields by (default is ',')
    /// - parameter encoding: encoding used to read file (default is UTF-8)
    /// - parameter loadColumns: whether to populate the columns dictionary (default is true)
    /// - throws: CSVParseError when parsing the contents of `name` fails, or file loading errors.
    public convenience init(name: String, delimiter: Character = comma, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        let contents = try String(contentsOfFile: name, encoding: encoding)
    
        try self.init(string: contents, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    /// Load a CSV file from a URL
    ///
    /// - parameter url: url pointing to the file (will be passed to String(contentsOfURL:encoding:) to load)
    /// - parameter delimiter: character to split row and header fields by (default is ',')
    /// - parameter encoding: encoding used to read file (default is UTF-8)
    /// - parameter loadColumns: whether to populate the columns dictionary (default is true)
    /// - throws: CSVParseError when parsing the contents of `url` fails, or file loading errors.
    public convenience init(url: URL, delimiter: Character = comma, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        let contents = try String(contentsOf: url, encoding: encoding)
        
        try self.init(string: contents, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    /// Turn the CSV data into NSData using a given encoding
    open func dataUsingEncoding(_ encoding: String.Encoding) -> Data? {
        return description.data(using: encoding)
    }
}

extension CSV: CustomStringConvertible {
    public var description: String {
        return self.content.serialize(header: self.header, delimiter: self.delimiter)
    }
}
