//
//  CSV+DelimiterGuessing.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 21.12.21.
//  Copyright © 2021 SwiftCSV. All rights reserved.
//

import Foundation

extension CSV {
    public static let recognizedDelimiters = [CSV.comma, CSV.tab, CSV.semicolon]

    /// - Returns: Delimiter between cells based on the first line in the CSV. Falls back to comma.
    public static func guessedDelimiter(string: String) -> Character {
        // Trim newline and spaces, but keep tabs (as delimiters)
        var trimmedCharacters = CharacterSet.whitespacesAndNewlines
        trimmedCharacters.remove("\t")
        let line = string.trimmingCharacters(in: trimmedCharacters).firstLine

        var index = line.startIndex
        while index < line.endIndex {
            let character = line[index]
            switch character {
            case "\"":
                // When encountering an open quote, skip to the closing counterpart.
                // If none is found, skip to end of line.

                // 1) Advance one character to skip the quote
                index = line.index(after: index)

                // 2) Look for the closing quote and move current position after it
                if index < line.endIndex,
                   let closingQuoteInddex = line[index...].firstIndex(of: character) {
                    index = line.index(after: closingQuoteInddex)
                } else {
                    index = line.endIndex
                }
            case _ where recognizedDelimiters.contains(character):
                return character
            default:
                index = line.index(after: index)
            }
        }

        // Fallback value
        return comma
    }
}
