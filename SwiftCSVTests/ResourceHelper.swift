import Foundation

// Find url of resource.
// This is a workaround for Xcode, when testing from the Xcode project (not the SPM package) bundle.module is not available...

struct ResourceHelper {
    static func url(forResource name: String, withExtension type: String) -> URL? {
        
#if SWIFT_PACKAGE
        return Bundle.module.url(forResource: name, withExtension: type)
#else
        //	Xcode project
        let bundle = Bundle(for: NamedViewTests.self)
        
        //	In Xcode, folders are stripped from the resources folder.
        var finalName = name
        var slashCharSet = CharacterSet()
        slashCharSet.insert("/")
        let parts = name.components(separatedBy: slashCharSet)
        if parts.count > 1 {
            finalName = parts.last!
        }
        return bundle.url(forResource: finalName, withExtension: type)
#endif
    }
}
