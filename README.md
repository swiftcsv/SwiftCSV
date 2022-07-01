# SwiftCSV

![Swift 5.5](https://img.shields.io/badge/Swift-5.5-blue.svg?style=flat)
[![Platform support](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos%20%7C%20watchos-lightgrey.svg?style=flat-square)](https://github.com/swiftcsv/SwiftCSV/blob/master/LICENSE.md)
[![Build Status](https://img.shields.io/travis/swiftcsv/SwiftCSV/master.svg?style=flat-square)](https://travis-ci.org/swiftcsv/SwiftCSV)
[![Code coverage status](https://codecov.io/gh/swiftcsv/SwiftCSV/branch/master/graph/badge.svg)](https://codecov.io/gh/swiftcsv/SwiftCSV)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftCSV.svg?style=flat-square)](https://cocoapods.org/pods/SwiftCSV)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swiftcsv/SwiftCSV/blob/master/LICENSE.md)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswiftcsv%2FSwiftCSV%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/swiftcsv/SwiftCSV)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswiftcsv%2FSwiftCSV%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/swiftcsv/SwiftCSV)

Simple CSV parsing for macOS, iOS, tvOS, and watchOS.

## Usage

CSV content can be loaded using the `CSV` class:

```swift
import SwiftCSV

do {
    // As a string, guessing the delimiter
    let csv: CSV = try CSV(string: "id,name,age\n1,Alice,18")

    // Specifying a custom delimiter
    let tsv: CSV = try CSV(string: "id\tname\tage\n1\tAlice\t18", delimiter: "\t")

    // From a file (propagating error during file loading)
    let csvFile: CSV = try CSV(url: URL(fileURLWithPath: "path/to/users.csv"))

    // From a file inside the app bundle, with a custom delimiter, errors, and custom encoding.
    // Note the result is an optional.
    let resource: CSV? = try CSV(
        name: "users",
        extension: "tsv",
        bundle: .main,
        delimiter: "\t",
        encoding: .utf8)
} catch parseError as CSVParseError {
    // Catch errors from parsing invalid CSV
} catch {
    // Catch errors from trying to load files
}
```

### File Loading

The `CSV` class comes with initializers that are suited for loading files from URLs.

```swift
extension CSV {
    /// Load a CSV file from `url`.
    ///
    /// - parameter url: URL of the file (will be passed to `String(contentsOfURL:encoding:)` to load)
    /// - parameter delimiter: Character used to separate cells from one another in rows.
    /// - parameter encoding: Character encoding to read file (default is `.utf8`)
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing the contents of `url` fails, or file loading errors.
    public convenience init(url: URL,
                            delimiter: Delimiter,
                            encoding: String.Encoding = .utf8,
                            loadColumns: Bool = true) throws

    /// Load a CSV file from `url` and guess its delimiter from `CSV.recognizedDelimiters`, falling back to `.comma`.
    ///
    /// - parameter url: URL of the file (will be passed to `String(contentsOfURL:encoding:)` to load)
    /// - parameter encoding: Character encoding to read file (default is `.utf8`)
    /// - parameter loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - throws: `CSVParseError` when parsing the contents of `url` fails, or file loading errors.
    public convenience init(url: URL,
                            encoding: String.Encoding = .utf8,
                            loadColumns: Bool = true)
}
```

### Delimiters

Delimiters are strongly typed. The recognized `CSV.Delimiter` cases are: `.comma`, `.semicolon`, and `.tab`.

You can use convenience initializers that guess the delimiter from the recognized list for you. These initializers are available for loading CSV from URLs and strings.

You can also use any other single-character delimiter when loading CSV data. A character literal like `"x"` will produce `CSV.Delimiter.character("x")`, so you don't have to type the whole `.character(_)` case name. There are initializers for each variant that accept explicit delimiter settings.

### Reading Data

```swift
// Recognized the comma delimiter automatically:
let csv = CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19")
csv.header         //=> ["id", "name", "age"]
csv.namedRows      //=> [["id": "1", "name": "Alice", "age": "18"], ["id": "2", "name": "Bob", "age": "19"]]
csv.namedColumns   //=> ["id": ["1", "2"], "name": ["Alice", "Bob"], "age": ["18", "19"]]
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

### Skip Named Column Access for Large Data Sets

By default, the variants of `CSV.init` will populate its `namedColumns` and `enumeratedColumns` to provide access to the CSV data on a column-by-column basis. Think of this like a cross section:

```swift
let csv = CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19")
csv.namedRows[0]["name"]  //=> "Alice"
csv.namedColumns["name"]  //=> ["Alice", "Bob"]
```

If you only want to access your data row-by-row, and not by-column, then you can set the `loadColumns` argument in any initializer to `false`. This will prevent the columnar data from being populated.

Skipping this step can increase performance for lots of data.


## Installation

### CocoaPods

```ruby
pod "SwiftCSV"
```

### Carthage

```
github "swiftcsv/SwiftCSV"
```

### SwiftPM

```
.package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.6.1")
```
