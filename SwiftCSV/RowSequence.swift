//
//  RowSequence.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

struct RowGenerator: GeneratorType {
    typealias Element = String
    
    private var rows: [String]
    
    init(text: String) {
        rows = text.lines
        rows.removeAtIndex(0)
    }
    
    mutating func next() -> String? {
        return rows.isEmpty ? .None : rows.removeAtIndex(0)
    }
}

struct RowSequence: SequenceType {
    typealias Generator = RowGenerator
    
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func generate() -> RowGenerator {
        return RowGenerator(text: text)
    }
}
