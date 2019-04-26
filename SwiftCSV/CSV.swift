//
//  CSV.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

public enum Variant {
    case named
    case enumerated
}

public protocol View {
    associatedtype Rows
    associatedtype Columns

    var rows: Rows { get }
    var columns: Columns { get }

    init(header: [String], text: String, delimiter: Character, limitTo: Int?, loadColumns: Bool) throws
}

open class CSV {
    static public let comma: Character = ","
    
    public let header: [String]

    lazy var _namedView: NamedView = {
        return try! NamedView(
            header: self.header,
            text: self.text,
            delimiter: self.delimiter,
            loadColumns: self.loadColumns)
    }()

    lazy var _enumeratedView: EnumeratedView = {
        return try! EnumeratedView(
            header: self.header,
            text: self.text,
            delimiter: self.delimiter,
            loadColumns: self.loadColumns)
    }()

    var text: String
    var delimiter: Character

    let loadColumns: Bool

    /// List of dictionaries that contains the CSV data
    public var namedRows: [[String : String]] {
        return _namedView.rows
    }

    /// Dictionary of header name to list of values in that column
    /// Will not be loaded if loadColumns in init is false
    public var namedColumns: [String : [String]] {
        return _namedView.columns
    }

    /// Collection of column fields that contain the CSV data
    public var enumeratedRows: [[String]] {
        return _enumeratedView.rows
    }

    /// Collection of columns with metadata.
    /// Will not be loaded if loadColumns in init is false
    public var enumeratedColumns: [EnumeratedView.Column] {
        return _enumeratedView.columns
    }
    



    @available(*, unavailable, renamed: "namedRows")
    public var rows: [[String : String]] {
        return namedRows
    }

    @available(*, unavailable, renamed: "namedColumns")
    public var columns: [String : [String]] {
        return namedColumns
    }

    
    /// Load a CSV file from a string
    ///
    /// - parameter string: Contents of the CSV file
    /// - parameter delimiter: Character to split row and header fields by (default is ',')
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is true)
    /// - throws: CSVParseError when parsing `string` fails.
    public init(string: String, variant: Variant = .named, delimiter: Character = comma, loadColumns: Bool = true) throws {
        self.text = string
        self.delimiter = delimiter
        self.loadColumns = loadColumns
        self.header = try Parser.array(text: string, delimiter: delimiter, limitTo: 1).first ?? []
    }
    
    /// Load a CSV file
    ///
    /// - parameter name: name of the file (will be passed to String(contentsOfFile:encoding:) to load)
    /// - parameter delimiter: character to split row and header fields by (default is ',')
    /// - parameter encoding: encoding used to read file (default is UTF-8)
    /// - parameter loadColumns: whether to populate the columns dictionary (default is true)
    /// - throws: CSVParseError when parsing the contents of `name` fails, or file loading errors.
    public convenience init(name: String, variant: Variant = .named, delimiter: Character = comma, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        let contents = try String(contentsOfFile: name, encoding: encoding)
    
        try self.init(string: contents, variant: variant, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    /// Load a CSV file from a URL
    ///
    /// - parameter url: url pointing to the file (will be passed to String(contentsOfURL:encoding:) to load)
    /// - parameter delimiter: character to split row and header fields by (default is ',')
    /// - parameter encoding: encoding used to read file (default is UTF-8)
    /// - parameter loadColumns: whether to populate the columns dictionary (default is true)
    /// - throws: CSVParseError when parsing the contents of `url` fails, or file loading errors.
    public convenience init(url: URL, variant: Variant = .named, delimiter: Character = comma, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        let contents = try String(contentsOf: url, encoding: encoding)
        
        try self.init(string: contents, variant: variant, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    /// Turn the CSV data into NSData using a given encoding
    open func dataUsingEncoding(_ encoding: String.Encoding) -> Data? {
        return description.data(using: encoding)
    }
}
