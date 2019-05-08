import Foundation

struct ResourceHelper {
    static func url(forResource name: String, withExtension type: String) -> URL? {
        let bundle = Bundle(for: CSVTests.self)
        if let url = bundle.url(forResource: name, withExtension: type) {
            return url
        } else if let realBundle = Bundle(path: "\(bundle.bundlePath)/../../../../SwiftCSVTests") {
            return realBundle.url(forResource: name, withExtension: type)
        } else {
            return nil
        }
    }
}