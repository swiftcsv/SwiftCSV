//
//  FieldSequence.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import Foundation

struct FieldGenerator: GeneratorType {
    typealias Element = String
    
    private var fields: [String]
    private var headerGenerator: HeaderGenerator
    private var index = 0
    
    init(text: String, headerSequence: HeaderSequence) {
        let delim = headerSequence.delimiter
        let escape: Character = "\\"
        let quote: Character = "\""
        let quoteCharSet = NSCharacterSet(charactersInString: "\"")
        fields = [String]()
        
        var inQuotes = false
        var lastIndex = text.startIndex
        var currentIndex = text.startIndex
        
        while currentIndex < text.endIndex {
            let char = text[currentIndex]
            if !inQuotes && char == delim {
                let field = text.substringWithRange(lastIndex..<currentIndex)
                // TODO it would be nice to not trim this
                fields.append(field.stringByTrimmingCharactersInSet(quoteCharSet))
                lastIndex = currentIndex.advancedBy(1)
            }
            if char == quote {
                inQuotes = !inQuotes
            }
            currentIndex = currentIndex.advancedBy(char == escape ? 2 : 1)
        }
        let field = text.substringWithRange(lastIndex..<currentIndex)
        fields.append(field.stringByTrimmingCharactersInSet(quoteCharSet))
        
        headerGenerator = headerSequence.generate()
    }
    
    mutating func next() -> String? {
        switch headerGenerator.next() {
        case .Some(_):
            let val = index < fields.count ? fields[index] : ""
            index += 1
            return val
        case .None:
            return .None
        }
    }
}

struct FieldSequence: SequenceType {
    typealias Generator = FieldGenerator
    
    private let text: String
    private let headerSequence: HeaderSequence
    
    init(text: String, headerSequence: HeaderSequence) {
        self.text = text
        self.headerSequence = headerSequence
    }
    
    func generate() -> FieldGenerator {
        return FieldGenerator(text: text, headerSequence: headerSequence)
    }
}
