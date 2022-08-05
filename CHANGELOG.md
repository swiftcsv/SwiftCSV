<!--
## 0.0.0

API Changes:

Bugfixes:

Other:
-->

## 0.7.1

API Changes:

Bugfixes:

- Backport of fix from 0.8.1 to 0.7.x: Strip byte order mark from Strings when importing so they don't become part of imported content's cells. 
  See #97 for discussion. (#104) -- @lardieri

Other:


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
