//
//  HeaderSequence.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

struct HeaderGenerator: GeneratorType {
    typealias Element = String
    
    private var fields: [String]
    
    init(text: String, delimiter: NSCharacterSet) {
        let header = text.lines[0]
        fields = header.componentsSeparatedByCharactersInSet(delimiter)
    }
    
    mutating func next() -> String? {
        return fields.isEmpty ? .None : fields.removeAtIndex(0)
    }
}

struct HeaderSequence: SequenceType {
    typealias Generator = HeaderGenerator
    
    private let text: String
    let delimiter: NSCharacterSet
    
    init(text: String, delimiter: NSCharacterSet) {
        self.text = text
        self.delimiter = delimiter
    }
    
    func generate() -> HeaderGenerator {
        return HeaderGenerator(text: text, delimiter: delimiter)
    }
}
