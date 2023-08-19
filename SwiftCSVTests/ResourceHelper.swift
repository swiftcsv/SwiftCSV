import Foundation

// Find url of resource.
// This is a workaround for SwiftPM, because SwiftPM does not yet support for including resources with targets.(https://bugs.swift.org/browse/SR-2866)
struct ResourceHelper {
    static func url(forResource name: String, withExtension type: String) -> URL? {
        print("ResourceHelper.url(forResource: \(name), withExtension: \(type)")
        let bundle = Bundle(for: NamedViewTests.self)
        print("Bundle(for: NamedViewTests.self): \(bundle).")
        if let url = bundle.url(forResource: name, withExtension: type) {
            return url
        } else if let realBundle = Bundle(path: "\(bundle.bundlePath)/../../../../SwiftCSVTests") {
            print("Falling back to hard-coded bundle path.  \(bundle.bundlePath)/../../../../SwiftCSVTests")
            return realBundle.url(forResource: name, withExtension: type)
        } else {
            return nil
        }
    }
}
