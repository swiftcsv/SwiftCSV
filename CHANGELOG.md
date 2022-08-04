<!--
## 0.0.0

API Changes:

Bugfixes:

Other:
-->

## 0.8.1 (current)

API Changes:

Bugfixes:

- Strip byte order mark from Strings when importing so they don't become part of imported content's cells. 
  See #97 for discussion. (#103) -- @lardieri

Other:


## 0.8.0

API Changes:

- Replace namedRows/namedColumns and enumeratedRows/enumeratedColumns with CSV<Named> and CSV<Enumerated> types
  that both expose a rows/columns property with different types. This way you cannot screw up by trying to access
  an unpopulated array because the CSV was loaded wrongly. The type knows it all. (#76) -- @DivineDominion
    - CSV.namedRows/CSV.namedColumns and CSV.enumeratedRows/CSV.enumeratedColumns are removed.
    - NamedCSV/EnumeratedCSV type aliases are introduced to simplify access.

## 0.7.0

API Changes:

- Introduce delimiter guessing (#100) - @DivineDominion


## 0.6.1

Bugfixes:

- Fix enumeration limit being ignored in `Parser` (#98) - @jasonmedeiros 


## 0.6.0

API Changes:

- Rename `View` to `CSVView` to avoid SwiftUI namespace conflicts (#93) - @campionfellin

Other:

- Bump iOS Deployment target to 9.0, Xcode 12 recommended changes. (#91) - @DenTelezhkin
