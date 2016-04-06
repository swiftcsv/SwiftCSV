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
        fields = text.componentsSeparatedByCharactersInSet(headerSequence.delimiter)
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
