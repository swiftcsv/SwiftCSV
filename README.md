# SwiftCSV

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
let csv = CSV(contentsOfURL: url)

// Rows
let rows = csv.rows
let headers = csv.headers  //=> ["id", "name", "age"]
let alice = csv.rows[0]    //=> ["id": 1, "name": "Alice", "age": 18]
let bob = csv.rows[1]      //=> ["id": 2, "name": "Bob", "age": 19]

// Columns
let columns = csv.columns
let names = csv.columns["name"]  //=> ["Alice", "Bob", "Charlie"]
let ages = csv.columns["age"]    //=> [18, 19, 20]
```

### Other formats

Also, you can parse other formats such as TSV by using `init(contentsOfURL:separator:)`.

```swift
let tsvURL = NSURL(string: "users.tsv")
let tab = NSCharacterSet(charactersInString: "\t")
let tsv = CSV(contentsOfURL: tsvURL, separator: tab)
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

