# SwiftCSV

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Usage

```csv
id,name,age
1,Alice,18
2,Bob,19
3,Charlie,20
```

```swift
do {
    let csv = try CSV(name: "users.csv")
    csv.rows[0]         //=> [1, "Alice", 18]
    csv.columns["age"]  //=> [18, 19, 20]
} catch CSVError.FileNotFound(let name) {
    print("File not found: \(name)")
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

## Author

[naoty](https://github.com/naoty)

