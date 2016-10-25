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

/// CSV variant for which unique column names are assumed.
///
/// Example:
///
///     let csv = NamedCSV(...)
///     let allIds = csv.columns["id"]
///     let firstEntry = csv.rows[0]
///     let fullName = firstEntry["firstName"] + " " + firstEntry["lastName"]
///
typealias NamedCSV = CSV<NamedView>

/// CSV variant that exposes columns and rows as arrays.
/// Example:
///
///     let csv = EnumeratedCSV(...)
///     let allIds = csv.columns.filter { $0.header == "id" }.rows
///
typealias EnumeratedCSV = CSV<EnumeratedView>

open class CSV<DataView : View>  {
    public static var comma: Character { return "," }
    
    public let header: [String]

    /// Unparsed contents.
    public let text: String

    /// Used delimiter to parse `text` and to serialize the data again.
    public let delimiter: Character

    /// Underlying data representation of the CSV contents.
    public let content: DataView

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
    
    /// Turn the CSV contents into Data using a given encoding
    open func dataUsingEncoding(_ encoding: String.Encoding) -> Data? {
        return serialized.data(using: encoding)
    }

    /// Serialized form of the CSV data; depending on the View used, this may
    /// perform additional normalizations.
    open var serialized: String {
        return self.content.serialize(header: self.header, delimiter: self.delimiter)
    }
}

extension CSV: CustomStringConvertible {
    public var description: String {
        return self.serialized
    }
}
