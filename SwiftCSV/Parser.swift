//
//  Parser.swift
//  SwiftCSV
//
//  Created by Will Richardson on 13/04/16.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

extension CSV {
    /// Parse the file and call a block on each row, passing it in as a list of fields
    /// limitTo will limit the result to a certain number of lines
    func enumerateAsArray(block: [String] -> (), limitTo: Int?, startAt: Int = 0) {
        var currentIndex = text.startIndex
        let endIndex = text.endIndex
        
        var atStart = true
        var parsingField = false
        var parsingQuotes = false
        var innerQuotes = false
        
        var fields = [String]()
        var field = [Character]()
        
        var count = 0
        let doLimit = limitTo != nil
        
        let callBlock: () -> () = {
            fields.append(String(field))
            if count >= startAt {
                block(fields)
            }
            count += 1
            fields = [String]()
            field = [Character]()
        }
        
        let changeState: (Character) -> (Bool) = { char in
            if atStart {
                if char == "\"" {
                    atStart = false
                    parsingQuotes = true
                } else if char == self.delimiter {
                    fields.append(String(field))
                    field = [Character]()
                } else if CSV.isNewline(char) {
                    callBlock()
                } else {
                    parsingField = true
                    atStart = false
                    field.append(char)
                }
            } else if parsingField {
                if innerQuotes {
                    if char == "\"" {
                        field.append(char)
                        innerQuotes = false
                    } else {
                        fatalError("Can't have non-quote here: \(char)")
                    }
                } else {
                    if char == "\"" {
                        innerQuotes = true
                    } else if char == self.delimiter {
                        atStart = true
                        parsingField = false
                        innerQuotes = false
                        fields.append(String(field))
                        field = [Character]()
                    } else if CSV.isNewline(char) {
                        atStart = true
                        parsingField = false
                        innerQuotes = false
                        callBlock()
                    } else {
                        field.append(char)
                    }
                }
            } else if parsingQuotes {
                if innerQuotes {
                    if char == "\"" {
                        field.append(char)
                        innerQuotes = false
                    } else if char == self.delimiter {
                        atStart = true
                        parsingField = false
                        innerQuotes = false
                        fields.append(String(field))
                        field = [Character]()
                    } else if CSV.isNewline(char) {
                        atStart = true
                        parsingQuotes = false
                        innerQuotes = false
                        callBlock()
                    } else {
                        fatalError("Can't have non-quote here: \(char)")
                    }
                } else {
                    if char == "\"" {
                        innerQuotes = true
                    } else {
                        field.append(char)
                    }
                }
            } else {
                fatalError("me_irl")
            }
            return doLimit && count >= limitTo!
        }
        
        while currentIndex < endIndex {
            let char = text[currentIndex]
            if changeState(char) {
                break
            }
            currentIndex = currentIndex.successor()
        }
        
        if fields.count != 0 || field.count != 0 || (doLimit && count < limitTo!) {
            fields.append(String(field))
            block(fields)
        }
    }
    
    private static func isNewline(char: Character) -> Bool {
        return char == "\n" || char == "\r\n"
    }
}