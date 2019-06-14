import Foundation

// Find url of resource.
// This is a workaround for SwiftPM, becasue SwiftPM is not yet support for include resources with targets.(https://bugs.swift.org/browse/SR-2866)
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
