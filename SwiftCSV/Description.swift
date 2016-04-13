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
        let head = header.joinWithSeparator(",") + "\n"
        
        let cont = rows.map { row in
            header.map { row[$0]! }.joinWithSeparator(",")
        }.joinWithSeparator("\n")
        return head + cont
    }
}