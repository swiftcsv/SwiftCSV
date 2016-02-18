//
//  HeaderSequence.swift
//  SwiftCSV
//
//  Created by Naoto Kaneko on 2/18/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

struct HeaderGenerator: GeneratorType {
    typealias Element = String
    
    private var fieldGenerator: FieldGenerator
    
    init(text: String) {
        var rowGenerator = RowGenerator(text: text)
        let header = rowGenerator.next()
        fieldGenerator = FieldGenerator(text: header!)
    }
    
    mutating func next() -> String? {
        return fieldGenerator.next()
    }
}

struct HeaderSequence: SequenceType {
    typealias Generator = HeaderGenerator
    
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func generate() -> HeaderGenerator {
        return HeaderGenerator(text: text)
    }
}
