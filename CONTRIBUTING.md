# Contributing to SwiftCSV

Pull requests are welcome on the [`master`](https://github.com/swiftcsv/SwiftCSV) branch.

We know making you first pull request can be scary. If you have trouble with any of the contribution rules, **still make the Pull Request**. We are here to help.

We personally think the best way to get started contributing to this library is by using it in one of your projects!

## Swift style guide

We follow the [Ray Wenderlich Style Guide](https://github.com/raywenderlich/swift-style-guide) very closely with the following exception:

- Use the Xcode default of 4 spaces for indentation.

## SwiftLint

[SwiftLint](https://github.com/realm/SwiftLint) will run automatically on all pull requests via [houndci.com](https://houndci.com/). If you have SwiftLint installed, you will receive the same warnings in Xcode at build time, that hound will check for on pull requests.

Function body lengths in tests will often cause a SwiftLint warning. These can be handled on a per case bases by prefixing the function with:

```swift
// swiftlint:disable function_body_length
func someFunctionThatShouldHaveAReallyLongBody() {}
```

Common violations to look out for are trailing white and valid docs.

## Tests

All code going into master requires testing. We strive for code coverage of 100% to ensure the best possibility that all edge cases are tested for. It's good practice to test for any variations that can cause nil to be returned.

Tests are run in [Travis CI](https://travis-ci.org/swiftcsv/SwiftCSV) automatically on all pull requests, branches and tags. These are the same tests that run in Xcode at development time.

## Comments

- **Readable code should be preferred over commented code.**

    Comments in code are used to document non-obvious use cases. For example, when the use of a piece of code looks unnecessary, and naming alone does not convey why it is required.

- **Comments need to be updated or removed if the code changes.**

    If a comment is included, it is just as important as code and has the same technical debt weight. The only thing worse than a unneeded comment is a comment that is not maintained.

## Code documentation

Code documentation is different from comments. Please be liberal with code docs.

When writing code docs, remember they are:

- Displayed to a user in Xcode quick help
- Used to generate API documentation
- API documentation also generates Dash docsets

In particular paying attention to:

- Keeping docs current
- Documenting all parameters and return types (SwiftLint helps with warning when they are not valid)
- Stating common issues that a user may run into

See [NSHipster Swift Documentation](http://nshipster.com/swift-documentation/) for a good reference on writing documentation in Swift.

## Pull Request Technicalities

You're always welcome to open Pull Requests, even if the result is not quite finished or you need feedback!

Here's a checklist for you about what makes Pull Requests to SwiftCSV shine:

* Run [SwiftLint](https://github.com/realm/SwiftLint) locally to ensure your code-style is consistent with the rest of the codebase.
* Keep your Pull Requests focused. Rather be opening multiple PRs than making a dozen unrelated but discussion worthy changes in a single PR.
* You can propose PRs to merge with the `master` branch directly. We don't use any complex branching strategies.

**As a contributor,** choose the "squash & merge" strategy to merge PRs with a single commit, keeping the commit history clean. (That's an upside of focused Pull Requests: you don't lose extra information.)

## Publishing New Releases

Members of the [@SwiftCSV/releases](https://github.com/orgs/swiftcsv/teams/releases) team have the necessary permissions to publish a new version to CocoaPods. If you want a new version of SwiftCSV to be published you should ping these folks.

To create a new release, create a pull request targeting either `master`, or a separate release branch for hot-fixes, with the following:

- [ ] Bump version number in `SwiftCSV.podspec` and `Info.plist` (We follow [semver](https://semver.org/) - most importantly any breaking API change should result in a major API version bump)
- [ ] Create a tag off of the relevant branch (`master` for regular release) and add relevant changelog entries to the [release list on GitHub](https://github.com/swiftcsv/SwiftCSV/releases) 
- [ ] Publish the new version to the CocoaPods trunk via `pod trunk push`

