Pod::Spec.new do |s|
  s.name         = "SwiftCSV"
  s.version      = "0.4.0"
  s.summary      = "CSV parser for Swift"
  s.homepage     = "https://github.com/naoty/SwiftCSV"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Naoto Kaneko" => "naoty.k@gmail.com" }
  s.source       = { :git => "https://github.com/swiftcsv/SwiftCSV.git", :tag => s.version }
  s.swift_versions = ["4.2"]

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"

  s.source_files = "SwiftCSV/**/*.swift"
  s.requires_arc = true
end
