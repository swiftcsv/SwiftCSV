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
    
    private var tokens: [String]
    
    init(text: String) {
        let comma = NSCharacterSet(charactersInString: ",")
        tokens = text.componentsSeparatedByCharactersInSet(comma)
    }
    
    mutating func next() -> String? {
        return tokens.isEmpty ? .None : tokens.removeAtIndex(0)
    }
}

struct FieldSequence: SequenceType {
    typealias Generator = FieldGenerator
    
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func generate() -> FieldGenerator {
        return FieldGenerator(text: text)
    }
}
