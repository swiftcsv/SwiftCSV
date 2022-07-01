# SwiftCSV

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
    let csv: CSV = try CSV<Named>(string: "id,name,age\n1,Alice,18")

    // Specifying a custom delimiter
    let tsv: CSV = try CSV<Enumerated>(string: "id\tname\tage\n1\tAlice\t18", delimiter: .tab)

    // From a file (propagating error during file loading)
    let csvFile: CSV = try CSV<Named>(url: URL(fileURLWithPath: "path/to/users.csv"))

    // From a file inside the app bundle, with a custom delimiter, errors, and custom encoding.
    // Note the result is an optional.
    let resource: CSV? = try CSV<Named>(
        name: "users",
        extension: "tsv",
        bundle: .main,
        delimiter: .character("🐠"),  // Any character works!
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
    /// - Parameters:
    ///   - url: URL of the file (will be passed to `String(contentsOfURL:encoding:)` to load)
    ///   - delimiter: Character used to separate separate cells from one another in rows.
    ///   - encoding: Character encoding to read file (default is `.utf8`)
    ///   - loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - Throws: `CSVParseError` when parsing the contents of `url` fails, or file loading errors.
    public convenience init(url: URL,
                            delimiter: CSVDelimiter,
                            encoding: String.Encoding = .utf8,
                            loadColumns: Bool = true) throws

    /// Load a CSV file from `url` and guess its delimiter from `CSV.recognizedDelimiters`, falling back to `.comma`.
    ///
    /// - Parameters:
    ///   - url: URL of the file (will be passed to `String(contentsOfURL:encoding:)` to load)
    ///   - encoding: Character encoding to read file (default is `.utf8`)
    ///   - loadColumns: Whether to populate the columns dictionary (default is `true`)
    /// - Throws: `CSVParseError` when parsing the contents of `url` fails, or file loading errors.
    public convenience init(url: URL,
                            encoding: String.Encoding = .utf8,
                            loadColumns: Bool = true)
}
```

### Delimiters

Delimiters are strongly typed. The recognized `CSVDelimiter` cases are: `.comma`, `.semicolon`, and `.tab`.

You can use convenience initializers that guess the delimiter from the recognized list for you. These initializers are available for loading CSV from URLs and strings.

You can also use any other single-character delimiter when loading CSV data. A character literal like `"x"` will produce `CSV.Delimiter.character("x")`, so you don't have to type the whole `.character(_)` case name. There are initializers for each variant that accept explicit delimiter settings.

### Reading Data

```swift
// Recognized the comma delimiter automatically:
let csv = CSV<Named>(string: "id,name,age\n1,Alice,18\n2,Bob,19")
csv.header         //=> ["id", "name", "age"]
csv.rows           //=> [["id": "1", "name": "Alice", "age": "18"], ["id": "2", "name": "Bob", "age": "19"]]
csv.columns        //=> ["id": ["1", "2"], "name": ["Alice", "Bob"], "age": ["18", "19"]]
```

The rows can also parsed and passed to a block on the fly, reducing the memory needed to store the whole lot in an array:

```swift
// Access each row as an array (inner array not guaranteed to always be equal length to the header)
csv.enumerateAsArray { array in
    print(array.first)
}
// Access them as a dictionary
csv.enumerateAsDict { dict in
    print(dict["name"])
}
```

### Skip Named Column Access for Large Data Sets

Use `CSV<Named>` aka `NamedCSV` to access the CSV data on a column-by-column basis with named columns. Think of this like a cross section:

```swift
let csv = NamedCSV(string: "id,name,age\n1,Alice,18\n2,Bob,19")
csv.rows[0]["name"]  //=> "Alice"
csv.columns["name"]  //=> ["Alice", "Bob"]
```

If you only want to access your data row-by-row, and not by-column, then you can use `CSV<Enumerated>` or `EnumeratedCSV`:

```swift
let csv = EnumeratedCSV(string: "id,name,age\n1,Alice,18\n2,Bob,19")
csv.rows[0][1]          //=> "Alice"
csv.columns?[0].header  //=> "name"
csv.columns?[0].rows    //=> ["Alice", "Bob"]
```

To speed things up, skip populating by-column access completely by passing `loadColums: false`. This will prevent the columnar data from being populated. For large data sets, this saves a lot of iterations (at quadratic runtime).

```swift
let csv = EnumeratedCSV(string: "id,name,age\n1,Alice,18\n2,Bob,19", loadColumns: false)
csv.rows[0][1]  //=> "Alice"
csv.columns     //=> nil
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

### SwiftPM

```
.package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.8.0")
```
