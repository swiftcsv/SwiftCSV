# SwiftCSV

![Swift 5.0](https://img.shields.io/badge/Swift-5.0-blue.svg?style=flat)
[![Platform support](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos%20%7C%20watchos-lightgrey.svg?style=flat-square)](https://github.com/swiftcsv/SwiftCSV/blob/master/LICENSE.md) 
[![Build Status](https://img.shields.io/travis/swiftcsv/SwiftCSV/master.svg?style=flat-square)](https://travis-ci.org/swiftcsv/SwiftCSV) 
[![Code coverage status](https://codecov.io/gh/swiftcsv/SwiftCSV/branch/master/graph/badge.svg)](https://codecov.io/gh/swiftcsv/SwiftCSV)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftCSV.svg?style=flat-square)](https://cocoapods.org/pods/SwiftCSV) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swiftcsv/SwiftCSV/blob/master/LICENSE.md) 
[![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg?style=flat-square)](https://houndci.com)


Simple CSV parsing for macOS, iOS, tvOS, and watchOS.

## Usage

CSV content can be loaded using the `CSV` class:

```swift
import SwiftCSV

do {
    // As a string
    let csv: CSV = try CSV(string: "id,name,age\n1,Alice,18")

    // With a custom delimiter character
    let tsv: CSV = try CSV(string: "id\tname\tage\n1\tAlice\t18", delimiter: "\t")

    // From a file (with errors)
    let csvFile: CSV = try CSV(url: URL(fileURLWithPath: "path/to/users.csv"))

    // From a file inside the app bundle, with a custom delimiter, errors, and custom encoding
    let resource: CSV? = try CSV(
        name: "users", 
        extension: "tsv", 
        bundle: .main, 
        delimiter: "\t", 
        encoding: .utf8)
} catch parseError as CSVParseError {
    // Catch errors from parsing invalid formed CSV
} catch {
    // Catch errors from trying to load files
}
```

### API

If you don't care about accessing named columns, you can set the `loadColumns` argument to `false` and the columns Dictionary will not be populated. This can increase performance in critical cases for lots of data.

```swift
class CSV {
    /// Load CSV data from a string.
    ///
    /// - parameter string: CSV contents to parse.
    /// - parameter delimiter: Character used to separate  row and header fields (default is ',')
    /// - parameter loadColumns: Whether to populate the `columns` dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing `string` fails.
    public init(string: String, 
                delimiter: Character = comma, 
                loadColumns: Bool = true) throws
                
    /// Load a CSV file as a named resource from `bundle`.
    ///
    /// - parameter name: Name of the file resource inside `bundle`.
    /// - parameter ext: File extension of the resource; use `nil` to load the first file matching the name (default is `nil`)
    /// - parameter bundle: `Bundle` to use for resource lookup (default is `.main`)
    /// - parameter delimiter: Character used to separate row and header fields (default is ',')
    /// - parameter encoding: encoding used to read file (default is `.utf8`)
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing the contents of the resource fails, or file loading errors.
    /// - returns: `nil` if the resource could not be found
    public convenience init?(
        name: String, 
        extension ext: String? = nil, 
        bundle: Bundle = .main, 
        delimiter: Character = comma, 
        encoding: String.Encoding = .utf8, 
        loadColumns: Bool = true) throws

    /// Load a CSV file from `url`.
    ///
    /// - parameter url: URL of the file (will be passed to `String(contentsOfURL:encoding:)` to load)
    /// - parameter delimiter: Character used to separate row and header fields (default is ',')
    /// - parameter encoding: Character encoding to read file (default is `.utf8`)
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing the contents of `url` fails, or file loading errors.
    public convenience init(
        url: URL, 
        delimiter: Character = comma, 
        encoding: String.Encoding = .utf8, 
        loadColumns: Bool = true)
}

public enum CSVParseError: Error {
    case generic(message: String)
    case quotation(message: String)
}
```

### Reading Data

```swift
let csv = CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19")
csv.header    //=> ["id", "name", "age"]
csv.rows      //=> [["id": "1", "name": "Alice", "age": "18"], ["id": "2", "name": "Bob", "age": "19"]]
csv.columns   //=> ["id": ["1", "2"], "name": ["Alice", "Bob"], "age": ["18", "19"]]
```

The rows can also parsed and passed to a block on the fly, reducing the memory needed to store the whole lot in an array:

```swift
// Access each row as an array (array not guaranteed to be equal length to the header)
csv.enumerateAsArray { array in
    print(array.first)
}
// Access them as a dictionary
csv.enumerateAsDict { dict in
    print(dict["name"])
}
```

## Installation

### CocoaPods

```ruby
pod "SwiftCSV"
```

### Carthage

```
github "swiftcsv/SwiftCSV"
```
