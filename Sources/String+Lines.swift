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
        let chars = characters
        while current < endIndex && chars[current] != "\r\n" && chars[current] != "\n" && chars[current] != "\r" {
            current = self.index(after: current)
        }
        return substring(to: current)
    }
}
