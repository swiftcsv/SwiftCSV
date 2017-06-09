//
//  Description.swift
//  SwiftCSV
//
//  Created by Will Richardson on 11/04/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

extension CSV: CustomStringConvertible {
    public var description: String {
        let head = header.joined(separator: ",") + "\n"
        
        let cont = namedRows.map { row in
            header.map { row[$0]! }.joined(separator: ",")
        }.joined(separator: "\n")
        return head + cont
    }
}
