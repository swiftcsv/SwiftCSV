//
//  CSV.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

open class CSV {
    static fileprivate let comma: Character = ","
    
    open let header: [String]

    lazy var _namedView: NamedView = {

        var rows = [[String: String]]()
        var columns = [String: [String]]()

        self.enumerateAsDict { dict in
            rows.append(dict)
        }

        if self.loadColumns {
            for field in self.header {
                columns[field] = rows.map { $0[field] ?? "" }
            }
        }

        return NamedView(rows: rows, columns: columns)
    }()

    lazy var _enumeratedView: EnumeratedView = {

        var rows = [[String]]()
        var columns: [EnumeratedView.Column] = []
        self.enumerateAsArray { rows.append($0) }

        if self.loadColumns {
            columns = self.header.enumerated().map { (index: Int, header: String) -> EnumeratedView.Column in

                return EnumeratedView.Column(
                    header: header,
                    rows: rows.map { $0[index] })
            }
        }

        return EnumeratedView(rows: rows, columns: columns)
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
    public init(string: String, delimiter: Character = comma, loadColumns: Bool = true) {
        self.text = string
        self.delimiter = delimiter
        self.loadColumns = loadColumns
        self.header = CSV.array(text: string, delimiter: delimiter).first ?? []
    }
    
    /// Load a CSV file
    ///
    /// - parameter name: name of the file (will be passed to String(contentsOfFile:encoding:) to load)
    /// - parameter delimiter: character to split row and header fields by (default is ',')
    /// - parameter encoding: encoding used to read file (default is UTF-8)
    /// - parameter loadColumns: whether to populate the columns dictionary (default is true)
    public convenience init(name: String, delimiter: Character = comma, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        let contents = try String(contentsOfFile: name, encoding: encoding)
    
        self.init(string: contents, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    /// Load a CSV file from a URL
    ///
    /// - parameter url: url pointing to the file (will be passed to String(contentsOfURL:encoding:) to load)
    /// - parameter delimiter: character to split row and header fields by (default is ',')
    /// - parameter encoding: encoding used to read file (default is UTF-8)
    /// - parameter loadColumns: whether to populate the columns dictionary (default is true)
    public convenience init(url: URL, delimiter: Character = comma, encoding: String.Encoding = .utf8, loadColumns: Bool = true) throws {
        let contents = try String(contentsOf: url, encoding: encoding)
        
        self.init(string: contents, delimiter: delimiter, loadColumns: loadColumns)
    }
    
    /// Turn the CSV data into NSData using a given encoding
    open func dataUsingEncoding(_ encoding: String.Encoding) -> Data? {
        return description.data(using: encoding)
    }
}
