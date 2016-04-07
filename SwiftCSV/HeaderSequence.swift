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
    
    init(text: String, delimiter delim: Character) {
        let header = text.getLines(1)[0]
        
        let escape: Character = "\\"
        let quote: Character = "\""
        let quoteCharSet = NSCharacterSet(charactersInString: "\"")
        fields = [String]()
        
        var inQuotes = false
        var lastIndex = header.startIndex
        var currentIndex = header.startIndex
        
        while currentIndex < header.endIndex {
            let char = header[currentIndex]
            if !inQuotes && char == delim {
                let field = header.substringWithRange(lastIndex..<currentIndex)
                // TODO it would be nice to not trim this
                fields.append(field.stringByTrimmingCharactersInSet(quoteCharSet))
                lastIndex = currentIndex.advancedBy(1)
            }
            if char == quote {
                inQuotes = !inQuotes
            }
            currentIndex = currentIndex.advancedBy(char == escape ? 2 : 1)
        }
        let field = header.substringWithRange(lastIndex..<currentIndex)
        fields.append(field.stringByTrimmingCharactersInSet(quoteCharSet))
    }
    
    mutating func next() -> String? {
        return fields.isEmpty ? .None : fields.removeAtIndex(0)
    }
}

struct HeaderSequence: SequenceType {
    typealias Generator = HeaderGenerator
    
    private let text: String
    let delimiter: Character
    
    init(text: String, delimiter: Character) {
        self.text = text
        self.delimiter = delimiter
    }
    
    func generate() -> HeaderGenerator {
        return HeaderGenerator(text: text, delimiter: delimiter)
    }
}
