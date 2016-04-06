//
//  String+Lines.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/24/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

extension String {
    /// Returns the first `count` lines of this string as a list
    func getLines(count: Int) -> [String] {
        var lines: [String] = []
        var index = 1
        self.enumerateLines { line, stop in
            lines.append(line)
            stop = index >= count
            index += 1
        }
        return lines
    }
    var lines: [String] {
        var lines = [String]()
        self.enumerateLines({ line, _ in lines.append(line) })
        return lines
    }
}
