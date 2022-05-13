//
//  CSV.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

public protocol CSVView {
    associatedtype Rows
    associatedtype Columns

    var rows: Rows { get }
    var columns: Columns { get }

    init(header: [String], text: String, delimiter: CSV.Delimiter, limitTo: Int?, loadColumns: Bool) throws
}

open class CSV {
    public enum Delimiter: Equatable, ExpressibleByUnicodeScalarLiteral {
        public typealias UnicodeScalarLiteralType = Character

        case comma, semicolon, tab
        case character(Character)

        public init(unicodeScalarLiteral: Character) {
            self.init(rawValue: unicodeScalarLiteral)
        }

        init(rawValue: Character) {
            switch rawValue {
            case ",":  self = .comma
            case ";":  self = .semicolon
            case "\t": self = .tab
            default:   self = .character(rawValue)
            }
        }

        public var rawValue: Character {
            switch self {
            case .comma: return ","
            case .semicolon: return ";"
            case .tab: return "\t"
            case .character(let character): return character
            }
        }
    }
    
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
    var delimiter: Delimiter

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


    /// Load CSV data from a string.
    ///
    /// - parameter string: CSV contents to parse.
    /// - parameter delimiter: Character used to separate cells from one another in rows.
    /// - parameter loadColumns: Whether to populate the `columns` dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing `string` fails.
    public init(string: String, delimiter: Delimiter, loadColumns: Bool = true) throws {
        self.text = string
        self.delimiter = delimiter
        self.loadColumns = loadColumns
        self.header = try Parser.array(text: string, delimiter: delimiter, rowLimit: 1).first ?? []
    }

    /// Load CSV data from a string and guess its delimiter from `CSV.recognizedDelimiters`, falling back to `.comma`.
    ///
    /// - parameter string: CSV contents to parse.
    /// - parameter loadColumns: Whether to populate the `columns` dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing `string` fails.
    public convenience init(string: String, loadColumns: Bool = true) throws {
        let delimiter = CSV.guessedDelimiter(string: string)
        try self.init(string: string, delimiter: delimiter, loadColumns: loadColumns)
    }

    /// Turn the CSV data into NSData using a given encoding
    open func dataUsingEncoding(_ encoding: String.Encoding) -> Data? {
        return description.data(using: encoding)
    }
}

extension CSV {
    /// Load a CSV file from `url`.
    ///
    /// - parameter url: URL of the file (will be passed to `String(contentsOfURL:encoding:)` to load)
    /// - parameter delimiter: Character used to separate cells from one another in rows.
    /// - parameter encoding: Character encoding to read file (default is `.utf8`)
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing the contents of `url` fails, or file loading errors.
    public convenience init(url: URL, delimiter: Delimiter, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        let contents = try String(contentsOf: url, encoding: encoding)

        try self.init(string: contents, delimiter: delimiter, loadColumns: loadColumns)
    }

    /// Load a CSV file from `url` and guess its delimiter from `CSV.recognizedDelimiters`, falling back to `.comma`.
    ///
    /// - parameter url: URL of the file (will be passed to `String(contentsOfURL:encoding:)` to load)
    /// - parameter encoding: Character encoding to read file (default is `.utf8`)
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing the contents of `url` fails, or file loading errors.
    public convenience init(url: URL, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        let contents = try String(contentsOf: url, encoding: encoding)

        try self.init(string: contents, loadColumns: loadColumns)
    }
}

extension CSV {
    /// Load a CSV file as a named resource from `bundle`.
    ///
    /// - parameter name: Name of the file resource inside `bundle`.
    /// - parameter ext: File extension of the resource; use `nil` to load the first file matching the name (default is `nil`)
    /// - parameter bundle: `Bundle` to use for resource lookup (default is `.main`)
    /// - parameter delimiter: Character used to separate cells from one another in rows.
    /// - parameter encoding: encoding used to read file (default is `.utf8`)
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing the contents of the resource fails, or file loading errors.
    /// - returns: `nil` if the resource could not be found
    public convenience init?(name: String, extension ext: String? = nil, bundle: Bundle = .main, delimiter: Delimiter, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            return nil
        }
        try self.init(url: url, delimiter: delimiter, encoding: encoding, loadColumns: loadColumns)
    }

    /// Load a CSV file as a named resource from `bundle` and guess its delimiter from `CSV.recognizedDelimiters`, falling back to `.comma`.
    ///
    /// - parameter name: Name of the file resource inside `bundle`.
    /// - parameter ext: File extension of the resource; use `nil` to load the first file matching the name (default is `nil`)
    /// - parameter bundle: `Bundle` to use for resource lookup (default is `.main`)
    /// - parameter encoding: encoding used to read file (default is `.utf8`)
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing the contents of the resource fails, or file loading errors.
    /// - returns: `nil` if the resource could not be found
    public convenience init?(name: String, extension ext: String? = nil, bundle: Bundle = .main, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            return nil
        }
        try self.init(url: url, encoding: encoding, loadColumns: loadColumns)
    }
}
