# SwiftCSV

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Requirements

* Xcode 6.1 or later

## Usage

For example, if you want to parse `users.csv` below,

```csv
id,name,age
1,Alice,18
2,Bob,19
3,Charlie,20
```

you can access data from rows and columns like this.

```swift
if let url = NSURL(string: "users.csv") {
    var error: NSErrorPointer = nil
    if let csv = CSV(contentsOfURL: url, error: error) {
        // Rows
        let rows = csv.rows
        let headers = csv.headers  //=> ["id", "name", "age"]
        let alice = csv.rows[0]    //=> ["id": "1", "name": "Alice", "age": "18"]
        let bob = csv.rows[1]      //=> ["id": "2", "name": "Bob", "age": "19"]

        // Columns
        let columns = csv.columns
        let names = csv.columns["name"]  //=> ["Alice", "Bob", "Charlie"]
        let ages = csv.columns["age"]    //=> ["18", "19", "20"]
    }
}
```

`CSV(contentsOfURL:error:)` will return `CSV?` type, because the initialization may fail.

### Other formats

You can parse other formats such as TSV by using `CSV(contentsOfURL:delimiter:error:)`.

```swift
if let url = NSURL(string: "users.tsv") {
    let tab = NSCharacterSet(charactersInString: "\t")
    var error: NSErrorPointer = nil
    if let tsv = CSV(contentsOfURL: url, delimiter: tab, error: error) {
        // ...
    }
}
```

## Installation

SwiftCSV is available through CocoaPods, to install it simply add the following line to your Podfile:

```ruby
platform :ios, "8.0"
pod "SwiftCSV"
```

SwiftCSV can also be installed using Carthage for version 0.1.1 and higher. To install, add the following to your Cartfile.

```
github "naoty/SwiftCSV" ~> 0.1.1
```

Then run `carthage update` and add the framework to your project. For more details, see the Carthage repository. 

## Contribution

1. Fork
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

SwiftCSV is available under the MIT license. See the LICENSE file for more info.

## Author

[naoty](https://github.com/naoty)

