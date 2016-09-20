//
//  Parser.swift
//  SwiftCSV
//
//  Created by Will Richardson on 11/04/16.
//  Copyright © 2016 JavaNut13. All rights reserved.
//

extension CSV {
    /// List of dictionaries that contains the CSV data
    public var rows: [[String: String]] {
        if _rows == nil {
            parse()
        }
        return _rows!
    }
    
    /// Dictionary of header name to list of values in that column
    /// Will not be loaded if loadColumns in init is false
    public var columns: [String: [String]] {
        if !loadColumns {
            return [:]
        } else if _columns == nil {
            parse()
        }
        return _columns!
    }
    
    /// Parse the file and call a block for each row, passing it as a dictionary
    public func enumerateAsDict(_ block: @escaping ([String: String]) -> ()) {
        let enumeratedHeader = header.enumerated()
        
        enumerateAsArray { fields in
            var dict = [String: String]()
            for (index, head) in enumeratedHeader {
                dict[head] = index < fields.count ? fields[index] : ""
            }
            block(dict)
        }
    }
    
    /// Parse the file and call a block on each row, passing it in as a list of fields
    public func enumerateAsArray(_ block: @escaping ([String]) -> ()) {
        self.enumerateAsArray(block, limitTo: nil, startAt: 1)
    }
    
    fileprivate func parse() {
        var rows = [[String: String]]()
        var columns = [String: [String]]()
        
        enumerateAsDict { dict in
            rows.append(dict)
        }

        if loadColumns {
            for field in header {
                columns[field] = rows.map { $0[field] ?? "" }
            }
        }
        
        _columns = columns
        _rows = rows
    }
}
