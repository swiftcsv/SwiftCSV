# SwiftCSV

[![Build Status](https://travis-ci.org/naoty/SwiftCSV.svg?branch=master)](https://travis-ci.org/naoty/SwiftCSV) [![Version](http://img.shields.io/cocoapods/v/SwiftCSV.svg?style=flat)](http://cocoadocs.org/docsets/SwiftCSV) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Usage

### Initialization

```swift
let csv = CSV(string: "id,name,age\n1,Alice,18")
```

```swift
let tab = NSCharacterset(charactersInString: "\t")
let tsv = CSV(string: "id\tname\tage\n1\tAlice\t18", delimiter: tab)
```

```swift
do {
    let csv = try CSV(name: "users.csv")
} catch {
    // Error handling
}
```

```swift
let tab = NSCharacterset(charactersInString: "\t")
do {
    let tsv = try CSV(name: "users.tsv", delimiter: tab, encoding: NSUTF8StringEncoding)
} catch {
    // Error handling
}
```

### Access to data

```swift
let csv = CSV(string: "id,name,age\n1,Alice,18\n2,Bob,19")
csv.header    //=> ["id", "name", "age"]
csv.rows      //=> [["id": "1", "name": "Alice", "age": "18"], ["id": "2", "name": "Bob", "age": "19"]]
csv.columns   //=> ["id": ["1", "2"], "name": ["Alice", "Bob"], "age": ["18", "19"]]
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

## Author

[naoty](https://github.com/naoty)

