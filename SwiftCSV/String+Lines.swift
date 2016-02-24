//
//  String+Lines.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/24/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

extension String {
    var lines: [String] {
        var lines: [String] = []
        self.enumerateLines { line, _ in lines.append(line) }
        return lines
    }
}
