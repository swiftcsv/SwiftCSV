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

// As a string
let csv = CSV(string: "id,name,age\n1,Alice,18")
// With a custom delimiter character
let tsv = CSV(string: "id\tname\tage\n1\tAlice\t18", delimiter: "\t")
// From a file (with errors)
do {
    let csv = try CSV(name: "users.csv")
} catch {
    // Catch errors or something
}
// With a custom delimiter, errors, and custom encoding
do {
    let tsv = try CSV(name: "users.tsv", delimiter: tab, encoding: NSUTF8StringEncoding)
} catch {
    // Error handling
}
```

If you don't care about the columns, you can set the `loadColumns` argument to `false` and the columns Dictionary will not be populated.

### Reading Data

Works just like the original:

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
