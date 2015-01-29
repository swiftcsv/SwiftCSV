# SwiftCSV

## Requirements

* Xcode 6.1 or later

## Usage

For example, if you want to parse a below `users.csv`,

```csv
id,name,age
1,Alice,18
2,Bob,19
3,Charlie,20
```

you can access data from rows and columns like this.

```swift
let csvURL = NSURL(string: "users.csv")
var error: NSErrorPointer = nil
let csv = CSV(contentsOfURL: csvURL, error: error)

// Rows
let rows = csv.rows
let headers = csv.headers  //=> ["id", "name", "age"]
let alice = csv.rows[0]    //=> ["id": "1", "name": "Alice", "age": "18"]
let bob = csv.rows[1]      //=> ["id": "2", "name": "Bob", "age": "19"]

// Columns
let columns = csv.columns
let names = csv.columns["name"]  //=> ["Alice", "Bob", "Charlie"]
let ages = csv.columns["age"]    //=> ["18", "19", "20"]
```

`CSV(contentsOfURL:error:)` will return `CSV?` type, because the initialization may be failed.

### Other formats

Also, you can parse other formats such as TSV by using `CSV(contentsOfURL:delimiter:error:)`.

```swift
let tsvURL = NSURL(string: "users.tsv")
let tab = NSCharacterSet(charactersInString: "\t")
var error: NSErrorPointer = nil
let tsv = CSV(contentsOfURL: tsvURL, delimiter: tab, error: error)
```

## Installation

SwiftCSV is available through CocoaPods, to install it simply add the following line to your Podfile:

```ruby
platform :ios, "8.0"
pod "SwiftCSV"
```

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

