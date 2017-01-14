//
//  EnumeratedView.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 25/10/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

public struct EnumeratedView {

    public struct Column {
        public let header: String
        public let rows: [String]
    }

    var rows: [[String]]
    var columns: [Column]
}
