//
//  String+Lines.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/24/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

extension String {
    var firstLine: String {
        var current = startIndex
        while current < endIndex && self[current] != "\r\n" && self[current] != "\n" && self[current] != "\r" {
            current = self.index(after: current)
        }
        return String(self[..<current])
    }
}
