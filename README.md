# SwiftCSV
[![Version](http://img.shields.io/cocoapods/v/SwiftCSV.svg?style=flat)](http://cocoadocs.org/docsets/SwiftCSV)

_Simple CSV parsing, for OSX and iOS._

## Usage

CSV content can be loaded using the `CSV` class:

```swift
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
github "naoty/SwiftCSV"
```
